# Y̊pipe - Easy Local AI Client & MCP Orchestration Engine
### Democratizing Enterprise-Grade Local AI.

[![Exclusive Technical Preview](https://img.shields.io/badge/Status-Technical_Preview-C7123A?style=for-the-badge)](https://ypipe.com)
[![Java Compatible](https://img.shields.io/badge/Platform-Java_Enterprise-38E7C1?style=for-the-badge)](https://iunera.com)

<p align="center">
  <img src="assets/logo-animation.svg" alt="Ypipe Logo Animation" width="200">
</p>

[**Y̊pipe**](https://ypipe.com) is an easy-to-use local AI client and MCP orchestration engine—a secure, **local desktop application** that makes offline AI practical. Run optimized models (CPU/GPU) on your own hardware with absolute data sovereignty and zero cloud dependencies. Chain specialized models via **Model Context Protocol (MCP)** and bind them to on-premise systems to execute secure, autonomous workflows.

> **Note:** Y̊pipe is the successor to **Data-Philter**. The legacy Data-Philter documentation and codebase are archived in [archive/data-philter/README.md](archive/data-philter/README.md).

The key goals of this project are: **Easy-to-use local AI, Data Sovereignty, Multi-Agent Systems, and Java-native stability - all on consumer enterprise hardware.**

In the 2026 AI landscape, Ypipe acts as the **Industrial Assembly Line** for local AI.

---

## 🖥️ Interface Preview

Ypipe runs entirely on your local machine, bringing a visual agentic client, local model manager, and one-click integrations together. You can explore the full-size interactive interface at [ypipe.com](https://ypipe.com).

### 💬 Private Agentic Chat
Interact directly with your offline LLMs using natural language. Query local databases, fetch system information, and trigger automation scripts securely without transmitting data over the internet.
![Private Agentic Chat](assets/screenshot-chat.png)

*   **Local LLM Chat:** Talk directly to offline models running on your CPU or GPU.
*   **Agentic Gearbox Suggestion:** Automatically recommends a fitting LLM model based on your system's CPU, GPU, and RAM capacity.
*   **Sovereign Data Execution:** Run queries against SQLite or Apache Druid with zero external network requests.
*   **System Automation:** Bind chat commands to trigger local scripts, legacy systems, and files safely.
*   **Zero Data Leaks:** Your prompt, context, and responses never leave your physical machine.

### ⚙️ Engine Foundry & Runtimes
Manage local runtimes and models with a built-in downloader, automatically assessing hardware to optimize CPU/GPU execution speed.
![Engine Foundry & Runtimes](assets/screenshot-engine.png)

*   **Hardware-Optimized Config:** Assess system memory to automatically enable Apple Silicon (Metal) or CPU/Vulkan acceleration.
*   **Model Downloader:** Direct search and one-click import from Hugging Face for optimized GGUF formats.
*   **Versatile Model Support:** Run specialized small models (800M parameters) up to larger reasoning models (31B+).
*   **Self-Contained Inference:** No external inference engines (like Ollama) need to be installed. Everything is fully built-in and runs out-of-the-box.

### 🔌 MCP Couplings (Integrations)
Connect your offline AI agent to external tools, database servers, web browsers, and file managers instantly.
![One-Click MCP Integrations](assets/screenshot-couplings.png)

*   **Blueprints & McpIntegrations:** Clear separation between static connection templates (Blueprints) and active running server instances (McpIntegrations).
*   **Dedicated Management UI:** An intuitive, dedicated Couplings dashboard to manage, register, and monitor all active MCP servers and blueprints.
*   **Fine-Grained Tool Control:** Full control over exposed tools, allowing you to disable specific tools, modify tool names, and rewrite descriptions.
*   **Zero-Dependency Runtimes:** Run local servers using stdio, npx, uvx, or JBang directly on ypipe's embedded Java foundation.

---
## 🌊 Quick Start (JBang)

Run Ypipe instantly without installation using JBang:

```bash
jbang ypipe@iunera/ypipe
```

---

## ⛲ Installation

Grab the latest binaries for your OS at [ypipe.com](https://ypipe.com) or download them directly from the [GitHub Releases](https://github.com/iunera/ypipe/releases):

*   **Windows:** [Installer (.msi)](https://github.com/iunera/ypipe/releases/download/windows/v1.2.3/YPipe-1.2.3.msi) or [AppImage (.zip)](https://github.com/iunera/ypipe/releases/download/windows/v1.2.3/ypipe-1.2.3-app-image.zip)
*   **macOS:** [Apple Silicon (.dmg)](https://github.com/iunera/ypipe/releases/download/macos/v1.2.3/YPipe-1.2.3.dmg)
*   **Linux:** [Ubuntu (.deb)](https://github.com/iunera/ypipe/releases/download/linux/v1.2.3/ypipe_1.2.3_amd64.deb), [RedHat (.rpm)](https://github.com/iunera/ypipe/releases/download/linux/v1.2.3/ypipe-1.2.3.x86_64.rpm), or [Tarball (.tar.gz)](https://github.com/iunera/ypipe/releases/download/linux/v1.2.3/YPipe-1.2.3-linux-amd64.tar.gz)
*   **Universal:** [Executable JAR](https://github.com/iunera/ypipe/releases/download/jar/v1.2.3/ypipe-1.2.3.jar) for any Java-enabled environment.

---

## <img src="assets/watermill.svg" width="32" style="filter: invert(100%); vertical-align: middle;">  Why Ypipe?
Most AI tools are built for "Chat." Ypipe is built for **Data Workflows.** Ypipe targets connections to your system, your local secrets, and running on small devices.

---

### <img src="assets/aqueduct.svg" width="32" style="filter: invert(100%); vertical-align: middle;"> Key Differentiators:
* **Our goal is simple AI:** We focus on ensuring that you do not need a doctorate to get a model and data docking running. We believe local AI needs to be accessible to everyone.
* **The Intelligence Switchboard:** Don't waste a 70B model on a 1B task. Ypipe lets you easily select models for sub-tasks. Imagine simple jobs utilizing tiny models for OCR or classification while reserving heavy compute for final synthesis. What works on your computer also runs easily on a server - this is how one gets AI into productive use.
* **Built for the Professional Environment:** Ypipe uses the **Model Context Protocol (MCP)** and standardized APIs to bridge local intelligence with your existing tools. Whether it's a local SQL database or a custom enterprise API, Ypipe provides the "dock" for your data.
* **Java-Native Stability:** No Python dependency hell. Ypipe is built on Java, fitting seamlessly into existing enterprise server architectures, high-security environments, and professional DevOps pipelines. The dependencies that are required for the outside world: Do not worry, Ypipe manages it.
* **Sovereign Geopatriation:** 100% of the data stays on your hardware. No cloud-routing, no data leaks, and zero external API costs. You own the infrastructure and the intelligence it produces.

---

## <img src="assets/water-pump.svg" width="32" style="filter: invert(100%); vertical-align: middle;"> Features

*   **Autonomous Agent Chains:** Orchestrate multiple local models to perform complex, multi-step tasks without human intervention.
*   **Semantic Continuity:** Preserves context throughout the pipeline, ensuring that specialized agents have the "full picture" of the workflow.
*   **Cross-Platform UI & Headless:** Run it with a full GUI on Windows/macOS/Linux or deploy it as a headless background service for automated enterprise logging and plausibility checks.
*   **OpenAI Compatibility:** Drop-in replacement for OpenAI-based tools—just redirect the base URL to your local Ypipe instance.

---

### <img src="assets/fire-hydrant.svg" width="32" style="filter: invert(100%); vertical-align: middle;"> Choosing Your AI Model

Ypipe removes the guesswork from local AI. You don't need to be a data scientist to select the right intelligence; Ypipe acts as a **Model Switchboard**, ensuring you use the most efficient engine for every specific task in your pipeline.

Ypipe features a built-in **Gearbox** that automatically assesses your local hardware (CPU, GPU, and RAM) and suggests appropriate models. Further, it auto-selects the best runtime for your hardware to run the models locally—ensuring that you do not need to deal with the complexity of local AI configuration.

---

## <img src="assets/tap.svg" width="32" style="filter: invert(100%); vertical-align: middle;"> One-Click Connectivity

Ypipe is built to be the universal docking station for the **Model Context Protocol (MCP)**. We have eliminated the "dependency hell" of manual installations.

*   **Zero-Dependency Setup:** One-click installation of MCP servers. Ypipe handles the environment, runtimes, and connections—no additional software or Python dependencies are required on your host machine.
*   **Built-in Specialized Servers:** Ypipe ships with a curated set of pre-defined MCP servers (including our own **Druid MCP Server**) for immediate enterprise utility. For community MCP servers, all MCP server definitions with NPX, UV, and JBang are supported.
*   **Community Expansion:** Effortlessly import any community-developed MCP server to instantly grant your local agents new capabilities, from database access to web-search tools.
*   **Intelligent Orchestration:** Ypipe doesn't just connect to MCP servers; it orchestrates them. It dynamically routes tasks to the specific models and MCP tools required at exactly the right moment in the pipeline.
*   **External Client Access:** Access all Ypipe tools from external MCP clients (like LibreChat or Claude Desktop) via `streamable-http`. See the [How-To: Access MCP Integrations](docs/howto-access-mcp-integrations.md) guide for details.

---

## ☸ Kubernetes Deployment

For enterprise-scale deployments, Ypipe is fully compatible with Kubernetes. Please [contact us](https://www.iunera.com/contact/) for details or if you have interest in our K8s operator for Ypipe.

---

## 🗲 Evolution & Vision

Ypipe operates on a **Continuous Release Stream**. Rather than waiting for static version milestones, we deploy incremental enhancements to the orchestration engine as the local AI landscape evolves. Our development is focused on the **industrialization of the "Last Mile"** of AI deployment.

### <img src="assets/rain.svg" width="32" style="filter: invert(100%); vertical-align: middle;">Current Strategic Focus:
*   **Agentic Gearbox Optimization:** Refining the "Model Switchboard" logic to further reduce latency and compute costs by routing tasks to the most efficient small models.
*   **Sovereign Connectivity:** Expanding the library of pre-defined enterprise "Docks" (SAP, internal SQL dialects, and legacy ERP systems).
*   **Contextual Integrity:** Enhancing the Semantic Reattachment engine to handle increasingly massive document hierarchies without context drift.
*   **Governance Layering:** Hardening the headless audit-log systems for high-compliance environments (Finance, Healthcare, and Defense).

### 🌈 The Vision:
We don't follow a fixed feature-path; we respond to the needs of the **Sovereign Enterprise**. Our goal is to ensure that Ypipe remains the most stable, Java-native bridge between raw local models and production-ready business value.

> *Note: Feature requests and architectural challenges from our [Consulting Partners](mailto:contact@iunera.com) directly prioritize the release stream.*

---

## ╟ Terms of Use & Proprietary Status

**Y̊pipe** is currently released as an **Exclusive Technical Preview**.

*   **Free for Use:** You are free to download, run, and integrate Ypipe into your personal or enterprise workflows during this preview period.
*   **Proprietary Rights:** All rights, title, and interest in and to the software (including the "Holon" orchestration logic and underlying architecture) remain the exclusive property of **iunera** and the respective developers.
*   **Restrictions:** Redistribution, modification, or decompilation of the Ypipe binaries is strictly prohibited without express written consent from iunera.
*   **Future Licensing:** iunera reserves the right to introduce commercial licensing tiers or modified terms of use as the project evolves toward full production release.

For custom licensing or white-label integration requests, please **[Contact our Architectural Team](mailto:contact@iunera.com)**.

---

## 🏗️ Developer & Maintainer

Ypipe is developed and maintained by **[iunera](https://www.iunera.com)**.

### 🧩 Enterprise Expertise
*   **AI-Powered Analytics:** Cutting-edge solutions for high-velocity data analysis.
*   **Data Platforms:** Experts in **Apache Druid**, Flink, Kubernetes, Kafka, and Spring.
*   **MCP Solutions:** Advanced Model Context Protocol implementations for legacy systems.
*   **Custom AI:** Tailored, sovereign AI development for high-compliance environments.

### 🛠 Architectural Support
Our team provides white-glove consulting for:
*   **Managed Deployment:** End-to-end server and orchestration setup.
*   **Legacy Integration:** Bridging **Y̊pipe** with proprietary document silos.
*   **Sovereign Governance:** Ensuring compliance with 2026 regional data standards.

**[Get Enterprise MCP Consulting →](https://www.iunera.com/enterprise-mcp-server-development/)** | **[Book a Strategy Briefing](mailto:consulting@iunera.com)**

---

### Contact & Support

Need help? Let us know!

- **Website**: [https://www.iunera.com](https://www.iunera.com)
- **Professional Services**: Contact us through [email](mailto:consulting@iunera.com?subject=Druid%20MCP%20Server%20inquiry) for [Apache Druid enterprise consulting, support and custom development](https://www.iunera.com/apache-druid-ai-consulting-europe/)

---

## 📜 Provenance
Ypipe is maintained by **iunera**, the team behind industry-recognized tech including the *Druid MCP Server*, *Fahrbar20*, and *License-Token*.

<p align="left">
  <img src="assets/logo-corporate.svg" alt="iunera Corporate Logo" width="150">
</p>

© 2026 Ypipe by iunera. All Rights Reserved.
[Imprint](https://iunera.com/imprint/) | [Privacy Policy](https://iunera.com/privacy-policy/)
