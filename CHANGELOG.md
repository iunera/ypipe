# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
