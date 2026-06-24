# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.3] - Tool Registry Refinements, Model Configuration Upgrades & Ollama Adapter Enhancements

This release introduces key parameter configuration upgrades for LLMs, refines tool registry search behavior, and enhances model adapter handling for Spring AI Ollama execution pipelines.

### 🚀 Key Features
* **Ollama Adapter & Execution Enhancements:** Overhauled local inference engine adapters (including Falcon, Gemma, Llama, and Qwen) with robust support for `temperature`, modality logic, and custom message types (`EngineAssistantMessage`/`EngineUserMessage`).
* **Tool Registry Refinements:** Optimized query similarity thresholds, streamlined callback lookups, and refined fallback mechanisms in the search registry for more responsive and reliable tool integration.
* **Model Configuration Sanitization:** Implemented automatic DNS-1123 compliance validation for model names and namespaces, instantly validating input when editing fields in the YAML configuration popups.

### 🛠 Improvements
* **Blueprint Action Updates:** Enhanced Clickhouse Playground and Druid blueprints with clarified action descriptions and more detailed server status checks.
* **Model Parameter Defaults:** Adjusted standard prompt configurations and default settings for Falcon and Gemma models, including optimized temperature defaults and an expanded context window of 65536 tokens for Gemma.
* **Release Artifacts & Runtimes:** Updated release dependencies, download URLs, and notification durations. Upgraded bundled execution environment toolchains to Node v26.3.1, uv 0.11.24, and JBang 0.139.3.

## [1.2.2] - Model Integration Fixes, Falcon Support & Prompt Optimization

This release addresses several startup and activation stability issues, introduces initial support for Falcon-based architectures, and refines system prompt formatting for improved model performance.

### 🛠 Improvements & Fixes
* **Model Activation:** Fixed a startup error when activating the first model on fresh, vanilla systems.
* **Concurrent Startup:** Resolved startup race conditions by disabling synchronous MCP client initialization on boot and increasing service health-check timeouts.
* **System Prompt & YAML Serialization:** Configured system prompt editing to correctly target the REST API, and enabled YAML literal block styling (`|`) for cleaner prompt serialization.
* **Falcon Model Support:** Introduced early-stage dialect adapter support for Falcon models.
* **Model Compatibility:** Optimized prompt adapters (including Qwen models) and improved context rendering, resulting in more reliable text generation.

## [1.2.1] - Performance Improvements, Resilient Service Boot, Live Log Console

This release significantly optimizes the YPipe startup time by introducing concurrent service initialization and improves boot resilience under slow-starting or offline MCP controller environments.

### 🚀 Key Features
* **Concurrent Service Startup:** Overhauled the main startup orchestrator to boot both the Spring Boot MCP Controller and the Coordinator applications in parallel background threads, cutting down cold boot and initialization latency by up to 60%.
* **Parallel McpIntegration Registration:** Parallelized the registration and handshake process of all persisted MCP servers. This cuts startup latency from the sum of all server connection times down to the duration of the single slowest server.
* **Resilient MCP Client Connection:** Introduced a background connection retry loop for the Coordinator's Spring AI MCP client. Bypassing the eager, blocking startup health verification prevents context initialization failures when the MCP Controller is not yet fully listening.
* **Granular Service Boot UI Overlay:** Reworked the application startup splash overlay to present individual status cards for each background service.
* **Live Log Console:** Integrated a standalone, monospaced live log viewer.
* **Theme Color Alignment:** Unified the dark theme background styling across the startup screen.
* **Parallelized Tool-Vectorstore Embedding:** Parallelized the generation of vector embeddings for all tools in the tool registry to optimize background synchronization performance.

### 🛠 Improvements
* **Runtime Dependency Updates:** Runtime build versions `lamacpp` updated to `b9596` and `lemonadeSdk` updated to `b1293`.

## [1.2.0] - Dynamic GitOps Auto-Discovery & Hot-Reloading & Couplings Architecture

This release builds upon the Unified GitOps Workspace by introducing zero-downtime hot-reloading and automated manifest generation. It ensures that the YPipe engine can dynamically adapt to file system changes, imports, and forks instantly without requiring an application restart, while aggressively protecting shared hardware resources.
In addition it's introduces the brand-new **Couplings** view. It formally introduces declarative `McpIntegration` and `McpIntegrationBlueprint` resource Kinds, providing a native management UI for MCP servers with granular control over tool naming, descriptions, and active status.
Last but not least we YPipe now supports the latest awesome Gemma4 12B model. 

### 🚀 Key Features
* **"Couplings" MCP Integration View:** Introduced a complete, native management UI ("Couplings") for MCP servers. Backed by declarative `McpIntegration` and `McpIntegrationBlueprint` resource Kinds, it grants granular control to customize tool names, rewrite descriptions, toggle individual tools on/off, and dynamically persist configurations on the fly.
* **Zero-Downtime Hot-Reloading:** Completely overhauled the Spring Context configuration binder. Dropping a new `.ypipe` file into the workspace, or forking an existing model, now synchronously hot-reloads the manifest into memory and instantly broadcasts state changes to the UI without crashing or requiring a reboot.
* **Auto-Import Pipeline (`import/`):** Introduced a dedicated `~/.ypipe/models/import/` staging directory. Dropping raw `.gguf` files here triggers an automated workflow that moves the file to managed storage, auto-detects its metadata, generates a pristine Kubernetes-style `.ypipe` manifest  `Kind: Model` on `apiVersion: coordinator.ypipe.com/v1`  in your GitOps repository, and injects the model live into the active catalog.
* **Reference-Counted Deletions:** Deleting models is now completely safe. The engine utilizes the `ypipe-fh1` FastHash registry to track physical file ownership across the entire catalog. Deleting a model fork will now safely preserve the underlying 40GB `.gguf` weights if they are still being referenced by the base model or other active agents.

### 🛠 Improvements
* **Always-Available Manifest Management:** Unlocked the model management context menu (`...`) in the UI. Users can now edit, configure, or delete `.ypipe` manifests at any time, even if the underlying physical weights are currently missing or deleted from the disk.
* **Evaluation Stability:** Added pre-flight readiness checks to the hardware evaluation service, preventing system crashes when attempting to benchmark models that are not fully downloaded or hydrated.
* **Synchronous State Resolution:** Eliminated race conditions between the backend property registry and the JavaFX UI, ensuring that visual components only refresh when the underlying data is fully validated and bound in RAM.

### 🤖 Model Catalog
* **Gemma 4 12B (ggml-org, Q4_K_M):** Added `gemma-4-12b` to the system model catalog. Dense 12B instruct model from Google, quantized to Q4_K_M by ggml-org. Available in two variants: text-only (LLM) and multimodal (VLM with SigLIP2 vision projector — requires a llama.cpp build with SigLIP2 support).

### ⚠️ Breaking Changes
* **Model Naming Convention:** YPipe now enforces a strict SDR (Standard Directory Registry) naming format for model files (e.g., prefixing with `ax_`). Existing model files in `~/.ypipe/models/gguf/` must be renamed to the new format or moved to the `import/` directory for automated migration. Alternatively, they can be downloaded again through the UI.
* **MCP Integration Migration:** Legacy MCP configurations are no longer supported. All MCP servers must be re-connected using the new "Couplings" management UI to generate the required declarative `.ypipe` manifests.
* **MCP Controller Management Tools:** The MCP tools used for managing the MCP controller itself have been updated and replaced by the new internal lifecycle management system.
* **Removal of MCP Example Tool:** The legacy MCP example tool has been removed from the distribution as it is superseded by the new declarative integration patterns.



## [1.1.2] - Inference Stability & Core Runtime Updates

Version 1.1.2 reinforces the internal inference execution pipeline by addressing environment-specific hardware acceleration constraints on Linux. This release ensures a more consistent and predictable runtime behavior across deployments while maintaining alignment with the latest underlying inference SDKs.

### 🚀 Key Features

* **Inference Pipeline Refinement:**
  Updated the core LlamaCPP and LemonadeSDK build configurations. This ensures seamless integration with recent upstream optimizations, providing a more robust foundation for high-performance, stateless model execution.

### 🛠 Improvements
* Synchronized internal application properties with the latest build versions for improved underlying SDK compatibility.

### 🐛 Bug Fixes
* Resolved an initialization and execution problem specific to OpenVINO hardware acceleration on Linux environments, restoring stable local inference.

## [1.1.1] - Runtime Environment Stabilization

This patch release prioritizes the predictability and isolation of the application's underlying execution environment. We have hardened the integration layer handling dynamically executed components to ensure strict adherence to bundled dependencies, preventing environmental drift.

### 🚀 Key Features

* **Strict Runtime Isolation:**
  The JBang execution pipeline has been restructured to strictly enforce the use of the bundled Java Runtime Environment (JRE) distributed via jpackage. By explicitly overriding `JAVA_HOME` and sanitizing the environment `PATH` prior to invocation, the application guarantees execution consistency and eliminates conflicts with pre-existing, system-level software installations.

### 🛠 Improvements
* Refined macOS DMG packaging scripts to better support bundled execution contexts.
* Synchronized version identifiers and release asset linkages across the project ecosystem.

### 🐛 Bug Fixes
* Resolved a critical startup sequence failure on macOS where the application would fail to launch when the `druid-mcp-server` was activated.

## [1.1.0] - Declarative Configuration & Expanded Execution Runtimes

Version 1.1.0 introduces a declarative, Kubernetes-inspired approach to model configurations, systematically replacing legacy catalog systems. This structural adjustment simplifies environment reproducibility and broadens the native runtime support for standard integrations.

### 🚀 Key Features

* **Declarative Configuration Architecture:**
  Transitioned model and MCP instance configurations to a Kubernetes-style definition pattern, accompanied by a new local file registry. This replaces the deprecated `LocalModelCatalogService` and legacy catalog structures, offering cleaner, immutable state definitions.
* **Expanded Stdio Client Ecosystem:**
  The Standard I/O Client Provider now natively supports industry-standard execution commands (`node` and `uv`). This facilitates seamless, low-overhead integration of JavaScript and modern Python-based MCP servers directly within the platform.
* **Enhanced Tool Orchestration:**
  Refined integration profiles and tool descriptions for data sources like Apache Druid and SQLite. Added new cluster monitoring actions and fine-tuned disabled-tool configurations to improve operational observability and execution safety.

### 🛠 Improvements
* Upgraded underlying runtime build targets, including LlamaCPP and LemonadeSDK, to maintain downstream compatibility and optimize performance.
* Re-engineered the UI notification system.
* Integrated core telemetry and metrics tracking into the stable deployment track.
* Optimized pipeline build steps and streamlined dependencies to reduce packaging overhead and artifact size.
* Improved Apache Druid support by enhancing query optimization and reducing latency.

### 🐛 Bug Fixes
* Addressed potential payload validation and checksum interference issues during application packaging.
* Resolved styling inconsistencies within notification cards to ensure cleaner presentation across environments.

### 🚀 Changes
* Remove GPT-OSS 20B support due to mishandling the tool calling. We will introduce a more robust alternative in the next releases.

## [1.0.3] - Unified Release Intelligence & Protocol Resilience

This release bridges the transparency gap between development cycles and the end-user experience by synchronizing architectural insights across both GitHub and the native application interface. In addition to these visibility improvements, version 1.0.3 hardens the MCP lifecycle with critical timing optimizations, ensuring the reliable deployment of data-intensive services and heavy-duty runtimes.

### 🚀 Key Features

*   **Automated Architectural Changelogs:**
    Introduction of an AI-driven release intelligence engine that translates complex commit histories into high-level technical narratives. This system ensures that every architectural shift is documented with precision, providing users with a clear understanding of the platform's evolution through interactive, refined Markdown delivery.

*   ** Release Synchronization:**
    Implementation of a unified delivery pipeline for release documentation, making technical updates natively accessible within both the YPipe UI and GitHub. This dual-presence strategy ensures that users remain informed of feature updates and breaking changes directly within their operating environment, maintaining a continuous feedback loop.

### 🛠 Improvements
*   **Protocol Stability:** Optimized request and initialization thresholds for `McpClient`, providing greater resilience during complex service handshakes and resource-heavy registrations.

### 🐛 Bug Fixes
*   **SQL MCP Installation Determinism:** Resolved a critical timing regression that previously obstructed the SQL MCP Server provisioning process. This fix addresses a race condition during initialization, ensuring reliable service registration for data-intensive runtimes.
*   **Polyglot Extraction Hardening:** Addressed minor regressions in the runtime extraction logic to maintain environment consistency across different host platforms.

## [1.0.2] - 2026-05-11

### 🚀 Features
- **models**: Integrated new model definitions into the system catalog.
- **ui**: Added default IQ column sorting and improved null value handling in ModelManagement table.
- **notifications**: Refactored `NotificationCard` into a standalone component and improved overlay handling.

### 🛠 Improvements
- **packaging**: Enabled native access for JavaFX graphics and web components in packaging scripts.
- **suggestions**: Unified toast styling across web and JavaFX, and simplified global suggestions handling.
- **gemma4**: Refined Gemma4 extraction and enhanced argument parsing.
- **filesystem**: Improved filesystem suggestions with allowed directory validation.

### 🐛 Bug Fixes
- **macos**: Fixed macOS update installer issues.
- **ui**: Removed unnecessary warning icon from system hint formatting.
- Fixed various styling and status handling issues in the notification system.
