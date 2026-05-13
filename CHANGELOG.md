# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
