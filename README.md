# Data Philter: Sovereign AI for Natural Language to SQL (NL2SQL) Analytics

Data Philter is a local-first conversational interface for your enterprise data. It serves as a sovereign AI gateway that translates Natural Language to SQL (NL2SQL), enabling data scientists, site reliability engineers (SREs), and business analysts to query complex databases like Apache Druid and ClickHouse using plain English.

Unlike cloud-based solutions that require sending your sensitive schema and data to external providers, Data Philter operates entirely within your infrastructure. By leveraging Local LLM technology and the Model Context Protocol (MCP), it ensures that your data remains private, secure, and under your complete control.

## Why Data Philter?

In the era of Generative AI, data privacy is paramount. Data Philter addresses the critical need for "Sovereign AI"—artificial intelligence that you own and operate.

*   **Natural Language to SQL (NL2SQL):** Democratize data access by allowing team members to ask questions like "Show me the top 5 revenue sources from last week" and instantly receive accurate SQL-generated results.
*   **Privacy-First & Local-First:** Designed to run completely offline or within your VPC. Your data never leaves your environment.
*   **Model Context Protocol (MCP) Standard:** Built on the robust MCP standard, ensuring standardized, reliable communication between the AI reasoning engine and your database drivers.
*   **Database Agnostic:** Currently supports high-performance OLAP databases including Apache Druid and ClickHouse, with an extensible architecture for future integrations.
*   **Safe Execution:** Default "Read-Only" mode ensures that AI-generated queries cannot accidentally modify or delete data, providing a safe sandbox for exploration.

## Key Features

*   **Local LLM Integration:** Seamlessly integrates with Ollama to run open-weight models like Llama 3, Phi-4, or iunera's fine-tuned `aura` models directly on your hardware (CPU or GPU).
*   **Hybrid AI Capability:** Offers the flexibility to switch between local models for maximum privacy and OpenAI's API for cases where external model reasoning is preferred.
*   **Apache Druid Native:** Deep integration with Apache Druid via the dedicated [Druid MCP Server](https://github.com/iunera/druid-mcp-server), supporting complex aggregations and time-series analysis.
*   **ClickHouse Support:** First-class support for ClickHouse, enabling fast analytical queries on massive datasets.
*   **Docker-Native Deployment:** Deploys in minutes using standard Docker Compose or Kubernetes workflows, fitting naturally into modern DevOps pipelines.

## Architecture Overview

Data Philter acts as an intelligent orchestration layer between the user and your data infrastructure.

1.  **User Interface:** The user submits a natural language query via the web interface.
2.  **Reasoning Engine (LLM):** The system uses a Local LLM (via Ollama) or an external provider to interpret the intent.
3.  **MCP Translation:** The core application utilizes the Model Context Protocol to translate the intent into a precise database query (e.g., Druid JSON-based query or ClickHouse SQL).
4.  **Execution & Safety:** The query is executed against the database in a read-only context.
5.  **Response Generation:** The raw data is formatted and presented back to the user, often with an explanation of how the result was derived.

## Quick Start Guide

You can have Data Philter running on your local machine in minutes.

### Prerequisites

*   **Docker** and **Docker Compose** installed.
*   Access to an existing **Apache Druid** or **ClickHouse** cluster.
*   (Optional) **Ollama** installed locally if you intend to use local models.

### Automatic Installation

We provide an automated script to handle the setup of environment variables and containers.

**macOS / Linux:**
```bash
curl -sL https://raw.githubusercontent.com/iunera/data-philter/main/install.sh | sh
```

**Windows (PowerShell):**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/iunera/data-philter/main/install.ps1' | Select-Object -ExpandProperty Content | Invoke-Expression"
```

### Manual Installation

For users who prefer granular control or need to integrate into existing compose files:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/iunera/data-philter.git
    cd data-philter
    ```

2.  **Configure Environment:**
    Create a `.env` file or modify the provided templates (`druid.env_template`, `clickhouse.env_template`) to include your database credentials.

3.  **Launch Services:**
    ```bash
    docker compose up -d
    ```

4.  **Access the Interface:**
    Navigate to `http://localhost:4000` in your web browser.

## Configuration and AI Models

Data Philter is highly configurable to suit your hardware capabilities and privacy requirements. Configuration is managed via the `app.env` file.

### Choosing Your AI Model

The `IUNERA_MODEL_TYPE` variable controls the reasoning engine:

*   **`ollama-m` (Medium Tier):** Uses `iunera/aura-m`. Ideal for Macbooks with M-series chips (8GB+ RAM). Balances speed and reasoning.
*   **`ollama-l` (Large Tier):** Uses `iunera/aura-l`. Recommended for production use cases requiring complex SQL generation. Requires 16GB+ RAM.
*   **`ollama-xl` (Extra Large):** Uses enterprise-grade open models (20B+ params). Requires significant hardware resources (64GB+ RAM or dedicated GPUs).
*   **`openai`:** Connects to OpenAI's API. Requires a valid API key set in `SPRING_AI_OPENAI_API_KEY`.

### Database Connection Security

Security is configured via specific environment files (e.g., `druid.env`). Key parameters include:

*   `DRUID_SSL_ENABLED`: Enforce TLS/SSL encryption for all data in transit.
*   `DRUID_MCP_READONLY_ENABLED`: Strictly enforces read-only permissions at the application level.
*   `DRUID_AUTH_USERNAME` / `PASSWORD`: Standard authentication credentials.

## Kubernetes Deployment

For enterprise-scale deployments, Data Philter is fully compatible with Kubernetes. We provide Kustomize manifests to streamline deployment to your cluster.

Refer to the [Kubernetes Deployment Guide](k8s/README.md) for detailed instructions on configuring PersistentVolumes, Services, and Ingress resources.

## Roadmap

We are committed to expanding the capabilities of Data Philter to support the evolving data landscape:

*   **Advanced Visualization:** Integration of a canvas-based UI for plotting data points and generating charts on the fly.
*   **Expanded Database Support:** Upcoming native support for InfluxDB and TimescaleDB to broaden time-series analysis capabilities.
*   **Report Generation:** Automated export of analysis sessions into Markdown or PDF reports.

## License

This project is open-source software licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for more information.

## About iunera

iunera specializes in:
- **AI-Powered Analytics**: Cutting-edge artificial intelligence solutions for data analysis
- **Enterprise Data Platforms**: Scalable data infrastructure and analytics platforms (Druid, Flink, Kubernetes, Kafka, Spring)
- **Model Context Protocol (MCP) Solutions**: Advanced MCP server implementations for various data systems
- **Custom AI Development**: Tailored AI solutions for enterprise needs

As veterans in Apache Druid iunera deployed and maintained a large number of solutions based on [Apache Druid](https://druid.apache.org/) in productive enterprise grade scenarios. Read more on our [blog](https://www.iunera.com/kraken/).

### Need Expert Apache Druid Consulting?

**Maximize your return on data** with professional Druid implementation and optimization services. From architecture design to performance tuning and AI integration, our experts help you navigate Druid's complexity and unlock its full potential.

**[Get Expert Druid Consulting →](https://www.iunera.com/apache-druid-ai-consulting-europe/)**


### Need Enterprise MCP Server / AI or LLM Development Consulting?

**ENTERPRISE AI INTEGRATION & CUSTOM MCP (MODEL CONTEXT PROTOCOL) SERVER DEVELOPMENT**

Iunera specializes in developing production-grade AI agents and enterprise-grade LLM solutions, helping businesses move beyond generic AI chatbots. They build secure, scalable, and future-ready AI infrastructure, underpinned by the Model Context Protocol (MCP), to connect proprietary data, legacy systems, and external APIs to advanced AI models.

**[Get Enterprise MCP Server Development Consulting →](https://www.iunera.com/enterprise-mcp-server-development/)**

For more information about our services and solutions, visit [www.iunera.com](https://www.iunera.com).

### Contact & Support

Need help? Let us know!

- **Website**: [https://www.iunera.com](https://www.iunera.com)
- **Professional Services**: Contact us through [email](mailto:consulting@iunera.com?subject=Druid%20MCP%20Server%20inquiry) for [Apache Druid enterprise consulting, support and custom development](https://www.iunera.com/apache-druid-ai-consulting-europe/)
- **Open Source**: This project is open source and community contributions are welcome

---

For commercial support, custom feature development, or architectural consulting, please visit [www.iunera.com](https://www.iunera.com) or contact our team directly.
