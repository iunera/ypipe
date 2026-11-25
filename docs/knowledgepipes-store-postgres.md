# PostgreSQL Store Integration (`PGVECTOR` & `POSTGRESQL_RELATIONAL`)

KnowledgePipes integrates with PostgreSQL both as a high-performance **semantic vector database** using the `pgvector` extension and as a **read-only structured relational query target**.

---

## 1. Storage Adapters

| Adapter Type | Primary Use Case | Embedding Generation | Ingestion Supported |
|---|---|---|---|
| **`PGVECTOR`** | Semantic similarity search, document chunk retrieval, hybrid filtering | Yes (configured embedding model) | Yes (chunks inserted into vector table) |
| **`POSTGRESQL_RELATIONAL`** | Structured data grounding, relational entity queries, lookup tables | No (zero vector embeddings) | No (read-only direct SQL query) |

---

## 2. PostgreSQL `pgvector` Vector Store

### Required Database DDL

When using `PGVECTOR`, the destination table in PostgreSQL must support vector embeddings with an appropriate distance indexing operator. 

Execute the following DDL script in your PostgreSQL database (adjust the table name and vector dimension according to your embedding model, e.g., 768 for `nomic-embed-text` / `bge-base`, 1536 for `text-embedding-3-small` / OpenAI, 384 for `all-MiniLM-L6-v2`):

```sql
-- 1. Enable the pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Create the vector storage table
CREATE TABLE IF NOT EXISTS vector_store (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    content text,
    metadata json,
    embedding vector(768)
);

-- 3. Create HNSW Cosine Distance Index for fast approximate nearest neighbor search
CREATE INDEX IF NOT EXISTS idx_vector_store_hnsw 
    ON vector_store USING HNSW (embedding vector_cosine_ops);
```

> [!TIP]
> The HNSW index (`vector_cosine_ops`) provides sub-millisecond approximate nearest neighbor lookup even with hundreds of thousands of document chunks.

---

## 3. Manifest Example: `PGVECTOR` Store

```yaml
apiVersion: rag.ypipe.com/v1
kind: KnowledgePipeStore
metadata:
  name: corporate-pgvector-store
  namespace: default
spec:
  displayName: "Corporate PostgreSQL Vector Store"
  description: "Enterprise knowledge repository running on PostgreSQL pgvector with HNSW cosine search."
  adapterType: PGVECTOR
  embeddingModel: nomic-embed-text
  physicalTarget:
    schemaName: public
    tableName: vector_store
    datasourceUrl: "jdbc:postgresql://localhost:5432/postgres"
    datasourceUser: "postgres"
    datasourcePassword: "password"
  vectorStoreConfig:
    type: PGVECTOR
    persistent: true
    vectorDimension: 768
    distanceType: COSINE
  ingestionConfig:
    enableChunkIngestion: true
    chunkSize: 500
    chunkOverlap: 50
    ingestionQueryTemplate: "INSERT INTO ${schemaName}.${tableName} (id, content, metadata, embedding) VALUES ('${chunk_id}', '${content}', '${metadata_json}', '${embedding_blob}')"
  retrievalQueryTemplate: "SELECT id, content, metadata, 1 - (embedding <=> :query_vector) AS score FROM ${schemaName}.${tableName} WHERE (${department} == '' OR metadata->>'department' = '${department}') ORDER BY embedding <=> :query_vector LIMIT 10"
  filterSchema:
    department:
      type: string
      displayName: "Department Filter"
      description: "Filter chunks by departmental ownership (e.g., ENGINEERING, FINANCE, HR)"
      defaultValue: ""
      enableSuggest: true
      suggestQuery: "ENGINEERING|FINANCE|HR|LEGAL|OPERATIONS"
```

---

## 4. Manifest Example: `POSTGRESQL_RELATIONAL` (Read-Only Structured SQL)

For traditional relational databases where embeddings are not used, use `POSTGRESQL_RELATIONAL`:

```yaml
apiVersion: rag.ypipe.com/v1
kind: KnowledgePipeStore
metadata:
  name: corporate-postgres-relational
  namespace: default
spec:
  displayName: "Corporate Employees Relational Database"
  description: "Direct JDBC query execution against PostgreSQL employee records table."
  adapterType: POSTGRESQL_RELATIONAL
  physicalTarget:
    schemaName: public
    tableName: employee_records
    datasourceUrl: "jdbc:postgresql://localhost:5432/postgres"
    datasourceUser: "postgres"
    datasourcePassword: "password"
  retrievalQueryTemplate: "SELECT employee_id, full_name, role, department, salary, hire_date FROM ${schemaName}.${tableName} WHERE department = '${department}' AND status = 'ACTIVE' LIMIT 20"
  filterSchema:
    department:
      type: string
      displayName: "Department"
      defaultValue: "ENGINEERING"
      enableSuggest: true
      suggestQuery: "ENGINEERING|SALES|MARKETING|SUPPORT"
```

---

## 5. Query Template Parameter Placeholders

When defining `retrievalQueryTemplate` and `ingestionQueryTemplate` for PostgreSQL stores, the following dynamic placeholders are evaluated by the SpEL engine:

| Placeholder | Evaluated Value |
|---|---|
| `${schemaName}` | Target schema name (e.g., `public`). |
| `${tableName}` | Target table name (e.g., `vector_store`). |
| `${chunk_id}` | Unique RFC-4122 UUID of the chunk. |
| `${content}` | Plaintext chunk content (escaped for SQL). |
| `${metadata_json}` | Document chunk metadata serialized as JSON string. |
| `${embedding_blob}` | Vector embedding formatted for SQL insertion. |
| `:query_vector` | Spring AI JDBC parameter for cosine distance operator (`<=>`). |
| `${<customParam>}` | Dynamic context query parameter passed at runtime (e.g., `${department}`). |
