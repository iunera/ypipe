# Embedded H2 Dynamic Vector Store (`EMBEDDED_H2`)

The `EMBEDDED_H2` storage adapter provides a **zero-configuration, self-contained semantic vector store**. It uses Spring AI's `SimpleVectorStore` in-memory vector index coupled with an embedded H2 database for automatic on-disk persistence across application restarts.

---

## 1. Key Characteristics

- **Zero External Infrastructure:** No Docker containers, PostgreSQL, or MariaDB instances required.
- **Dynamic Table Management:** When a new `KnowledgePipeStore` is saved or queried, the system automatically creates the dedicated schema and table in the embedded H2 database (`${ypipe.data}/workspace/cache/rag/h2/rag_local.mv.db`).
- **Dedicated Partitioning:** Each store can target its own schema partition (default: `PUBLIC`) and table (default: `local_knowledge` or customized per store).
- **Fast Similarity Search:** Uses Spring AI cosine similarity vector matching over normalized embedding arrays.

---

## 2. Dynamic H2 Table Schema

The dynamic table schema is created automatically by `RagH2DynamicTableRepository` when a store is initialized:

```sql
CREATE SCHEMA IF NOT EXISTS PUBLIC;

CREATE TABLE IF NOT EXISTS PUBLIC.local_knowledge (
    chunk_id VARCHAR(64) PRIMARY KEY,
    content CLOB NOT NULL,
    embedding_blob CLOB,
    metadata_json CLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

- **`chunk_id`**: RFC-4122 UUID or normalized deterministic UUID.
- **`content`**: Full chunk text stored as `CLOB`.
- **`embedding_blob`**: JSON serialized vector embedding array (`[0.05, 0.15, -0.25, ...]`).
- **`metadata_json`**: Arbitrary document and asset metadata stored as JSON string.
- **`created_at`**: Ingestion timestamp.

---

## 3. Manifest Example: `EMBEDDED_H2` Store

```yaml
apiVersion: rag.ypipe.com/v1
kind: KnowledgePipeStore
metadata:
  name: local-knowledge
  namespace: default
spec:
  displayName: "Local Embedded Knowledge Store"
  description: "Self-contained local vector store backed by dynamic H2 table persistence."
  adapterType: EMBEDDED_H2
  embeddingModel: nomic-embed-text
  physicalTarget:
    schemaName: PUBLIC
    tableName: local_knowledge
  vectorStoreConfig:
    type: SIMPLE
    persistent: true
    vectorDimension: 768
    distanceType: COSINE
  ingestionConfig:
    enableChunkIngestion: true
    chunkSize: 500
    chunkOverlap: 50
    ingestionQueryTemplate: "INSERT_CHUNK(chunk_id='${chunk_id}', content='${content}', embedding='${embedding_blob}')"
  retrievalQueryTemplate: "category == '${category}' AND doc_type == '${doc_type}'"
  filterSchema:
    category:
      type: string
      displayName: "Document Category"
      defaultValue: "GENERAL"
      enableSuggest: true
      suggestQuery: "GENERAL|ARCHITECTURE|OPERATIONS|TECHNICAL"
    doc_type:
      type: string
      displayName: "Document Type"
      defaultValue: "DOCUMENT"
      enableSuggest: true
      suggestQuery: "DOCUMENT|SPECIFICATION|MEETING_NOTES|RUNBOOK"
```

---

## 4. Ingestion & Retrieval Sandbox in Embedded H2

1. **Test Insertion Probe:**
   During store configuration or connection testing, `RagH2DynamicTableRepository` performs a safe insert-probe to verify that the target table exists and is writeable:
   ```sql
   INSERT INTO PUBLIC.local_knowledge (chunk_id, content, metadata_json) 
   VALUES ('probe_test_id', 'probe text', '{"test_key":"test_val"}');
   DELETE FROM PUBLIC.local_knowledge WHERE chunk_id = 'probe_test_id';
   ```

2. **Vector Store Ingestion (`INSERT_CHUNK`):**
   When assets are ingested into `EMBEDDED_H2`, document chunks are embedded via the resolved `EmbeddingModel`, converted to Spring AI `Document` instances, persisted to the dynamic H2 table, and synchronized with the in-memory `VectorStore`.

3. **Runtime Vector Filtering:**
   Retrieval query filters in `EMBEDDED_H2` evaluate Spring AI boolean filter expressions (e.g., `category == 'OPERATIONS' && doc_type == 'MEETING_NOTES'`) directly against document chunk metadata during similarity search.
