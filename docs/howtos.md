 # YPipe Guides & How-Tos

Welcome to the YPipe documentation index. Below you will find step-by-step guides, configuration how-tos, and references for setting up and orchestrating local AI workflows.

---

## 🚀 Running & Deploying YPipe

*   **[Headless & Web Mode Guide](HEADLESS.md)**
    Deploy YPipe on servers or Docker without a desktop JavaFX shell, and enable browser-based Web Mode (`ypipe.ui.webmode.enabled=true`) with customizable navigation tabs.
*   **[Proxy Settings Configuration](howto-configure-proxies.md)**
    Configure YPipe to download models and runtimes in restricted corporate network environments requiring HTTP/HTTPS proxies.
*   **[UI Scaling & Resolution Fixes](howto-fix-windows-scaling.md)**
    Resolve overlapping window, clipped borders, or high-DPI scaling issues on Windows 11 systems.
*   **[Install Guide (Debian / Ubuntu via `dpkg`)](howto-install-deb-package.md)**
    Step-by-step instructions to install the `.deb` package via `dpkg` and resolve missing system dependencies using `apt-get install -f`.
*   **[Uninstall & Purge Guide (Debian / Ubuntu)](howto-uninstall-and-purge-linux.md)**
    Step-by-step instructions to uninstall or completely purge YPipe and user data from `dpkg`/`apt`.

---

## 🔌 MCP Couplings & Integrations

*   **[Access MCP Integrations from External Clients](howto-access-mcp-integrations.md)**
    Expose local YPipe tools and agents to external clients (e.g. LibreChat, Claude Desktop) over `streamable-http`.
*   **[MCP Integration Blueprints](McpIntegrationBlueprints.md)**
    Author and orchestrate custom MCP servers, define tool metadata, and manage configurations.

---

## 🌊 SmartPipe Schemas

*   **[SmartPipe Schema Properties Reference](smartpipes-schema-properties.md)**
    Detailed property spec for configuring JSON schemas, validation rules, and pipelines.

---

## 📚 KnowledgePipes (RAG & Grounding Subsystem)

*   **[KnowledgePipes Overview & Domain Model](knowledgepipes-overview.md)**
    Architecture, declarative manifests triplet (`Asset` ➔ `Store` ➔ `Context`), and lifecycle.
*   **[PostgreSQL Store Integration (`PGVECTOR` & Relational)](knowledgepipes-store-postgres.md)**
    `pgvector` extension setup, DDL scripts, HNSW cosine index, structured relational SQL, and query templates.
*   **[MariaDB Store Integration (`MARIADB_VECTOR` & Relational)](knowledgepipes-store-mariadb.md)**
    Native MariaDB 11.7+ `VECTOR` datatype, DDL, `VEC_DISTANCE_COSINE`, and relational query execution.
*   **[Embedded H2 Dynamic Vector Store](knowledgepipes-store-embedded-h2.md)**
    Self-contained, zero-external-dependency local database with dynamic table persistence.
*   **[Assets & Ingestion Pipelines](knowledgepipes-assets-and-ingestion.md)**
    Document (`.md`, `.pdf`, `.docx`), directory, pre-chunked JSON, and CSV ingestion with streaming SSE progress.
*   **[Contexts & Retrieval Surface](knowledgepipes-contexts-and-retrieval.md)**
    Semantic retrieval boundaries, parameter pinning vs. dynamic bindings, metadata suggestions, and retrieval flows.


