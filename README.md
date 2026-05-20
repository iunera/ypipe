# Y̊pipe (formerly Data-Philter)
### Democratizing Enterprise-Grade Local AI Orchestration.

[![Exclusive Technical Preview](https://img.shields.io/badge/Status-Technical_Preview-C7123A?style=for-the-badge)](https://ypipe.com)
[![Java Compatible](https://img.shields.io/badge/Platform-Java_Enterprise-38E7C1?style=for-the-badge)](https://iunera.com)

<p align="center">
  <img src="assets/logo-animation.svg" alt="Ypipe Logo Animation" width="200">
</p>

[**Y̊pipe**](https://ypipe.com) is a secure, **local desktop application** that makes offline AI practical. It gives you the power to download and run optimized local models (CPU/GPU) on your own hardware, and orchestrate agentic workflows with absolute data sovereignty and zero cloud dependencies. As an **open orchestration engine**, Ypipe enables every business to chain these specialized local models seamlessly with **Model Context Protocol (MCP) servers**—such as databases, local browsers, and document managers—to deliver lean, private local business process agents.

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

*   **Unified MCP Protocol:** Bind local models to tools, SQL databases, web browsers, and file systems instantly.
*   **Pre-Configured Abilities:** One-click setup for Apache Druid, SQLite/Postgres, document managers, and Playwright browsers.
*   **No Dependency Hell:** Runs on ypipe's embedded Java engine—no complex Python or system dependencies required.
*   **Extensible Ecosystem:** Create, register, and hot-reload custom Model Context Protocol servers in any language.

---
## 🌊 Quick Start (JBang)

Run Ypipe instantly without installation using JBang:

```bash
jbang ypipe@iunera/ypipe
```

---

## ⛲ Installation

Grab the latest binaries for your OS at [ypipe.com](https://ypipe.com) or download them directly from the [GitHub Releases](https://github.com/iunera/ypipe/releases):

*   **Windows:** [Installer (.msi)](https://github.com/iunera/ypipe/releases/download/windows%2Fv1.0.0/YPipe-1.0.0.msi) or [AppImage (.zip)](https://github.com/iunera/ypipe/releases/download/windows%2Fv1.0.0/ypipe-1.0.0-app-image.zip)
*   **macOS:** [Apple Silicon (.dmg)](https://github.com/iunera/ypipe/releases/download/macos%2Fv1.0.0/YPipe-1.0.0.dmg)
*   **Linux:** [Ubuntu (.deb)](https://github.com/iunera/ypipe/releases/download/linux%2Fv1.0.0/ypipe_1.0.0_amd64.deb), [RedHat (.rpm)](https://github.com/iunera/ypipe/releases/download/linux%2Fv1.0.0/ypipe-1.0.0.x86_64.rpm), or [Tarball (.tar.gz)](https://github.com/iunera/ypipe/releases/download/linux%2Fv1.0.0/YPipe-1.0.0-linux-amd64.tar.gz)
*   **Universal:** [Executable JAR](https://github.com/iunera/ypipe/releases/download/jar%2Fv1.0.0/ypipe-1.0.0-cross-platform.jar) for any Java-enabled environment.

---

## <img src="assets/watermill.svg" width="32" style="filter: invert(100%); vertical-align: middle;">  Why Ypipe?
Most AI tools are built for "Chat." Ypipe is built for **Data Workflows.** Ypipe targets connections to your system, your local secrets, and running on small devices.

---

### <img src="assets/aqueduct.svg" width="32" style="filter: invert(100%); vertical-align: middle;"> Key Differentiators:
* **Our goal is simple AI:** We focus on ensuring that you do not need a doctorate to get a model and data docking running. We believe local AI needs to be accessible to everyone.
* **The Intelligence Switchboard:** Don't waste a 70B model on a 1B task. Ypipe lets you easily select models for sub-tasks. Imagine simple jobs utilizing tiny models for OCR or classification while reserving heavy compute for final synthesis. What works on your computer also runs easily on a server - this is how one gets AI into productive use.
* ** Built for the professional environment. Ypipe uses the **Model Context Protocol (MCP)** and standardized APIs to bridge local intelligence with your existing tools. Whether it's a local SQL database or a custom enterprise API, Ypipe provides the "dock" for your data.
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

Ypipe features a built-in **Gearbox** that automatically assesses your local hardware (CPU, GPU, and RAM) and suggests models according to yoru hardware.

Further, it auto-selects the best runtime for yoru hardware and runs the models you - ensuring that you do not need to be bothered with the complexity of local AI

---

## <img src="assets/tap.svg" width="32" style="filter: invert(100%); vertical-align: middle;"> One-Click Connectivity

Ypipe is built to be the universal docking station for the **Model Context Protocol (MCP)**. We have eliminated the "dependency hell" of manual installations.

*   **Zero-Dependency Setup:** One-click installation of MCP servers. ypipe handles the environment, runtimes, and connections—no additional software or Python dependencies are required on your host machine.
*   **Built-in Specialized Servers:** ypipe ships with a curated set of pre-defined MCP servers (including our own **Druid MCP Server**) for immediate enterprise utility. For community MCP servers, all mcp server definitions with NPX, UV, and JBang are supported.
*   **Community Expansion:** Effortlessly import any community-developed MCP server to instantly grant your local agents new capabilities, from database access to web-search tools.
*   **The Model Switchboard:** ypipe doesn't just connect to MCP; it orchestrates them. It uses the "Model Switchboard" to determine which agent needs which MCP tool at exactly the right moment in the pipeline.

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

## Developer <img src="https://www.iunera.com/wp-content/uploads/2020/01/iunera-logo-shadow.png" width="100" style="vertical-align: middle;">

### Enterprise Expertise
- **AI-Powered Analytics**: Cutting-edge artificial intelligence solutions for data analysis
- **Enterprise Data Platforms**: Scalable data infrastructure and analytics platforms (Druid, Flink, Kubernetes, Kafka, Spring)
- **Model Context Protocol (MCP) Solutions**: Advanced MCP server implementations for various data systems
- **Custom AI Development**: Tailored AI solutions for enterprise needs



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
    <img src="https://www.iunera.com/wp-content/uploads/2020/01/iunera-logo-shadow.png" alt="iunera Corporate Logo" width="150">
</p>

© 2026 Ypipe by iunera. All Rights Reserved.
[Imprint](https://iunera.com/imprint/) | [Privacy Policy](https://iunera.com/privacy-policy/)
