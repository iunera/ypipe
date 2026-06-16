# How to Access MCP Integrations in Ypipe via Streamable HTTP

This guide explains how to start Ypipe, configure Model Context Protocol (MCP) integrations, and access the aggregated MCP tools from external clients using the `streamable-http` transport protocol.

---

## 🧭 Overview

Ypipe acts as a centralized **MCP Gateway and Switchboard**. You can register multiple local or remote MCP servers inside Ypipe. Ypipe then aggregates all their capabilities and exposes them as a single, unified MCP server endpoint via the `streamable-http` (Server-Sent Events) protocol. This allows external MCP-compatible clients (like LibreChat, Spring AI, or Claude Desktop) to connect to Ypipe and access all downstream tools seamlessly.

```
┌─────────────────┐       ┌─────────────────┐       ┌────────────────────────┐
│  External Client│ ───►  │  Ypipe Gateway  │ ───►  │ Downstream MCP Servers │
│  (LibreChat,etc)│  mcp  │ (Port 12001/mcp)│       │ (Playwright, SQL, etc) │
└─────────────────┘       └─────────────────┘       └────────────────────────┘
```

---

## 1. Starting Ypipe

You can run Ypipe using **JBang** or by downloading the latest precompiled binaries for your operating system.

### Option A: Run Instantly with JBang
Ensure you have JBang installed, then run:
```bash
jbang ypipe@iunera/ypipe
```

### Option B: Run via Binary
Download the appropriate package for your system from the [Releases](https://github.com/iunera/ypipe/releases) page (Windows `.msi`, macOS `.dmg`, Linux `.deb`/`.rpm`, or cross-platform `.jar`) and launch the application.

By default, Ypipe's coordinator starts its HTTP server on port `12000` (or `12001` if `12000` is occupied) and binds the MCP gateway to `/mcp`.

---

## 2. Configuring the MCP Integrations (`McpIntegration`)

In Ypipe, MCP servers are declared using **McpIntegration** manifests. You can register them via the UI or by dropping YAML configuration files into the local workspace repository directory.

### Example Manifest: `playwright.ypipe`
Save the following configuration as a file named `playwright.ypipe` under `${ypipe.data}/workspace/repos/default/playwright.ypipe` (where `${ypipe.data}` defaults to `~/.ypipe`):

```yaml
apiVersion: "mcp.ypipe.com/v1"
kind: "McpIntegration"
metadata:
  name: "playwright"
  namespace: "default"
spec:
  displayName: "Web Browser Automation"
  mcpConfig:
    type: "stdio"
    command: "npx"
    args:
      - "@playwright/mcp@latest"
```

Once saved, Ypipe will automatically detect the file, boot the underlying Playwright MCP server process via `npx`, and register its tools dynamically.

> [!TIP]
> **Creating Blueprints:** If you want to define reusable templates (Blueprints) for MCP servers—complete with schemas, variables, tool overrides, and discovery prompts—see the [MCP Integration Blueprints Documentation](McpIntegrationBlueprints.md).

---

## 3. Accessing Tools via Streamable HTTP (`streamable-http`)

Once Ypipe is running and your integrations are active, Ypipe exposes all aggregated tools via a Server-Sent Events (SSE) streamable HTTP connection.

### Client Configuration
To connect an external client (like LibreChat or Spring AI), add the streamable-http connection settings to your client's MCP configuration file (e.g. `mcpServers.json`):

```json
{
    "mcpServers": {
        "default-server": {
            "type": "streamable-http",
            "url": "http://localhost:12001/mcp",
            "note": "For Streamable HTTP connections, add this URL directly in your MCP Client"
        }
    }
}
```

*Note: Replace `12001` with the actual port Ypipe is running on if it dynamic-shifted on startup.*

Now, your external LLM client can call any of the tools hosted inside Ypipe!
