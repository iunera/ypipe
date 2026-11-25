# MariaDB Store Integration (`MARIADB_VECTOR` & `MARIADB_RELATIONAL`)

KnowledgePipes provides support for **MariaDB 11.7+ Native Vector Search** using `VEC_DISTANCE_COSINE` and native vector columns, as well as **read-only relational SQL execution**.

---

## 1. Storage Adapters

| Adapter Type | Primary Use Case | Embedding Generation | Ingestion Supported |
|---|---|---|---|
| **`MARIADB_VECTOR`** | Semantic vector storage using native MariaDB 11.7+ `VECTOR` datatype | Yes (configured embedding model) | Yes (`VEC_FromText` insertion) |
| **`MARIADB_RELATIONAL`** | Structured data grounding, relational entity queries, transactional tables | No (zero vector embeddings) | No (read-only direct SQL query) |

---

## 2. MariaDB Vector Store

### Required Database DDL

When using `MARIADB_VECTOR`, create the destination table in MariaDB (11.7 or newer):

```sql
-- Create vector table with native MariaDB 11.7+ VECTOR datatype
CREATE TABLE IF NOT EXISTS vector_store (
    id VARCHAR(36) PRIMARY KEY,
    content LONGTEXT,
    metadata JSON,
    embedding VECTOR(768) NOT NULL
);
```

> [!NOTE]
> MariaDB 11.7+ stores vector embeddings directly in fixed-dimension `VECTOR(N)` columns. Distances are computed in SQL queries using the native function `VEC_DISTANCE_COSINE(embedding, :query_vector)`.

---

## 3. Manifest Example: `MARIADB_VECTOR` Store

```yaml
apiVersion: rag.ypipe.com/v1
kind: KnowledgePipeStore
metadata:
  name: clinical-mariadb-store
  namespace: default
spec:
  displayName: "Clinical Knowledge MariaDB Vector Store"
  description: "Medical research and patient protocol vector store hosted on MariaDB 11.7+ with native vector distance functions."
  adapterType: MARIADB_VECTOR
  embeddingModel: nomic-embed-text
  physicalTarget:
    schemaName: mariadb
    tableName: vector_store
    datasourceUrl: "jdbc:mariadb://localhost:3306/mariadb"
    datasourceUser: "mariadb"
    datasourcePassword: "password"
  vectorStoreConfig:
    type: MARIADB_VECTOR
    persistent: true
    vectorDimension: 768
    distanceType: COSINE
  ingestionConfig:
    enableChunkIngestion: true
    chunkSize: 500
    chunkOverlap: 50
    ingestionQueryTemplate: "INSERT INTO ${schemaName}.${tableName} (id, content, metadata, embedding) VALUES ('${chunk_id}', '${content}', '${metadata_json}', VEC_FromText('${embedding_blob}'))"
  retrievalQueryTemplate: "SELECT id, content, metadata, VEC_DISTANCE_COSINE(embedding, :query_vector) AS score FROM ${schemaName}.${tableName} WHERE (${department} == '' OR JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.department')) = '${department}') ORDER BY score ASC LIMIT 10"
  filterSchema:
    department:
      type: string
      displayName: "Clinical Department"
      description: "Filter chunks by clinical specialty"
      defaultValue: ""
      enableSuggest: true
      suggestQuery: "CARDIOLOGY|ONCOLOGY|NEUROLOGY|PEDIATRICS|RADIOLOGY"
```

---

## 4. Manifest Example: `MARIADB_RELATIONAL` (Read-Only Structured SQL)

```yaml
apiVersion: rag.ypipe.com/v1
kind: KnowledgePipeStore
metadata:
  name: clinical-patients-relational
  namespace: default
spec:
  displayName: "Clinical Patient Records"
  description: "Direct JDBC query execution against MariaDB patient demographic records."
  adapterType: MARIADB_RELATIONAL
  physicalTarget:
    schemaName: mariadb
    tableName: patient_records
    datasourceUrl: "jdbc:mariadb://localhost:3306/mariadb"
    datasourceUser: "mariadb"
    datasourcePassword: "password"
  retrievalQueryTemplate: "SELECT patient_id, full_name, admission_date, diagnosis_code, ward, attending_physician FROM ${schemaName}.${tableName} WHERE ward = '${ward}' LIMIT 25"
  filterSchema:
    ward:
      type: string
      displayName: "Hospital Ward"
      defaultValue: "ICU"
      enableSuggest: true
      suggestQuery: "ICU|GENERAL_A|GENERAL_B|PEDIATRICS|POST_OP"
```

---

## 5. MariaDB SQL Query Template Placeholders

| Placeholder | Evaluated Value |
|---|---|
| `${schemaName}` | Target database/schema name (e.g., `mariadb`). |
| `${tableName}` | Target table name (e.g., `vector_store`). |
| `${chunk_id}` | Unique RFC-4122 UUID string. |
| `${content}` | Text content of the chunk. |
| `${metadata_json}` | Document chunk metadata serialized as valid JSON. |
| `VEC_FromText('${embedding_blob}')` | MariaDB function parsing text vector array representation (e.g., `[0.1, 0.2, ...]`). |
| `VEC_DISTANCE_COSINE(embedding, :query_vector)` | MariaDB vector distance function yielding cosine similarity distance. |
| `${<customParam>}` | Dynamic context query parameter passed at runtime (e.g., `${ward}`). |
