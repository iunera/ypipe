# MCP Integration Blueprints

This directory contains YAML configuration files for **MCP Integration Blueprints**. A Blueprint is a template for a pre-configured and optimized Model Context Protocol (MCP) server integration.

Each file allows you to:
- **Define the MCP configuration** (`mcpConfig`) for one-click installation.
- **Declare Configuration Schema Variables** for user-provided configurations (URLs, credentials, etc.).
- **Provide tool overrides** (`tools`) to enrich descriptions, inject properties, hide properties, or add discovery hints.
- **Embed suggestions** (`suggestions`) directly into the resource declaration.
- **Disable tools** (`disabledTools`) that should not be exposed to the AI model.

---

## Gemini CLI Instruction

When validating or inspecting the detailed tool list of an MCP server with Gemini CLI. Run Websearch or Playwright to the github page of the mcpserver to verify the correct tool names. 
* never hallucinate a tool nor name. 
* never split the mcpserver name with underscores nor dashes. BAD: clickhouse-playground ; GOOD: clickhouseplayground

---

## File Naming and Location

Each file must be named after the blueprint it defines, matching its metadata name:

```
McpIntegrationBlueprints/<name>.ypipe
```

Example: `browser.ypipe`, `nextcloud.ypipe`, `druid.ypipe`

### Storage Locations

1. **Classpath Predefined Templates**: Read-only blueprints packaged inside the application classpath at `predefined/blueprints/`.
2. **Workspace Catalog (User Repositories)**: Blueprints imported or created by the user are stored in the local workspace directory:
   ```
   ${ypipe.data}/repos/<namespace>/<name>.ypipe
   ```
3. **Workspace System Overrides**: Customized properties for system-level predefined templates are stored at:
   ```
   ${ypipe.data}/systemoverrides/<name>.ypipe
   ```

---

## Kubernetes-Conforming YAML Schema

All blueprint files must match the **Kubernetes Custom Resource** (CR) inspired schema definition modeled by the `com.iunera.ypipe.domain.mcp` records:

```yaml
---
apiVersion: "mcp.ypipe.com/v1"
kind: "McpIntegrationBlueprint"
metadata:
  name: "browser"
  namespace: "system"
spec:
  displayName: "Web Browser"
  description: "A browser automation and web scraping server based on Playwright."
  
  # 1. Variables schema
  configurationSchema:
    VAR_NAME:
      type: "string" # or "boolean"
      required: true
      default: "http://localhost:18888"
      description: "Hint shown to user"
      sensitive: false

  # 2. Server connection type (stdio or streamable-http)
  mcpConfig:
    type: "stdio"
    command: "npx"
    args:
      - "@playwright/mcp@latest"
    env:
      KEY: "${VAR_NAME}"
    url: null
    headers: null

  # 3. Disabled tools list
  disabledTools:
    - "browser_install"

  # 4. Embedded starter suggestions
  suggestions:
    - id: "browser-browser-web-search"
      title: "Browser: Web Search"
      label: "Search for specific info"
      action: "Open the browser and search for 'latest iunera ypipe features'."
      actionType: null
      target: null

  # 5. Enrichment & security injections
  tools:
    browser_navigate:
      description: "Navigate to a URL."
      usageIntent: "To navigate to websites"
      discoveryHint: "Ensure url is strictly valid"
      properties:
        url:
          type: "string"
          description: "The url to open"
          x-ypipe-inject: "injectValue"
          x-ypipe-hidden: false

  # 6. Model-specific settings
  modelSemantics:
    qwen-3p5:
      systemPrompt: "Extra rules when using the browser with Qwen."
```

---

## Field Specifications

### Root Fields

| Field | Required | Type | Description |
|---|---|---|---|
| `apiVersion` | ✅ Yes | `String` | API version of the schema, typically `"mcp.ypipe.com/v1"`. |
| `kind` | ✅ Yes | `String` | Must be `"McpIntegrationBlueprint"` for blueprints. |
| `metadata` | ✅ Yes | `Object` | Object containing resource identifiers (`name`, `namespace`). |
| `spec` | ✅ Yes | `Object` | The core blueprint specification matching `McpIntegrationBlueprintSpec`. |

### Metadata Fields

| Field | Required | Type | Description |
|---|---|---|---|
| `name` | ✅ Yes | `String` | The unique name of this blueprint resource. |
| `namespace` | ✅ Yes | `String` | Namespace scope of the resource (typically `"system"` for predefined servers). |

### Spec Fields

| Field | Required | Type | Description |
|---|---|---|---|
| `displayName` | ❌ Optional | `String` | User-friendly label shown in the UI. |
| `description` | ❌ Optional | `String` | Human-friendly description of what this server provides. |
| `configurationSchema` | ❌ Optional | `Map<String, PropertyDefinition>` | Declarative config variables representing inputs needed to provision this server. |
| `mcpConfig` | ✅ Yes | `McpConfig` | Configuration details specifying how to boot the MCP server client. |
| `disabledTools` | ❌ Optional | `List<String>` | List of tool names to block entirely from the model. |
| `suggestions` | ❌ Optional | `List<Suggestion>` | Declarative suggestions to bootstrap user prompts in the chat UI. |
| `tools` | ❌ Optional | `Map<String, ToolOverride>` | Tool description enrichments and parameter adjustments. |
| `modelSemantics` | ❌ Optional | `Map<String, ModelSemanticOverride>` | Custom system prompt overrides grouped by model ID. |

---

## Configuration Variables Schema (`configurationSchema`)

Placeholders (defined under `configurationSchema`) can be referenced anywhere inside `mcpConfig` (like inside `args`, `env`, `url`, etc.) using the `${VARIABLE_NAME}` syntax.

> [!IMPORTANT]
> **Parameters in Args Resolved from Env**: 
> When configuring MCP servers, if needed to define parameters in the `args` array using placeholders (e.g., `--url=${SERVER_URL}` or `${SERVER_URL}`), and declare the actual mapping under the `env` block (e.g., `SERVER_URL: "${USER_INPUT_VAR}"`). This allows actual credentials/paths to be safely stored in the `env` block on disk and dynamically resolved into the arguments at runtime, preventing sensitive values from being hardcoded in process arguments.

### Property Definition Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `type` | `String` | `"string"` | Either `"string"` or `"boolean"`. Influences UI rendering (text field vs. checkbox). |
| `required` | `Boolean` | `false` | If true, user must provide a value before installation. |
| `default` | `String` | `null` | Pre-populated value shown in the UI. |
| `description` | `String` | `null` | Informative label or hint shown to the user. You can append `Options: choice1, choice2` to define dropdown suggestions. |
| `sensitive` | `Boolean` | `false` | If true, masks user inputs (e.g. for API keys and passwords). |
| `pattern` | `String` | `null` | Optional regex pattern to validate user input on save. |

> [!TIP]
> **Dropdown Suggestions**: 
> You can provide selection suggestions for a configuration variable in the UI by appending `Options: choice1, choice2, ...` or `Choices: choice1, choice2, ...` to the `description` string. The UI will automatically detect this syntax and render an editable `ComboBox` (dropdown), allowing the user to select one of the pre-configured choices or type a custom value.

---

## Tool Overrides (`tools`)

You can define semantic changes or security parameters for each tool under the `tools` map. Use the **original tool name** (without the server name prefix) as the key.

### Tool Override Fields

* `description`: Replaces the description sent to the model entirely. Keep it concise, action-oriented, and in the semantic domain of the tool.
* `usageIntent`: Explains *when* the model should choose this tool.
* `discoveryHint`: Detailed text used to index the tool in a Vector Store for semantic search. Because the AI model performs semantic search to discover tools dynamically, discovery hints should be highly descriptive and rich in keywords. Include synonyms, related terminology, common user intent scenarios, system components involved, and target questions the tool solves. A longer, comprehensive hint significantly improves tool discovery and query matching accuracy.
* `required`: List of parameters that are strictly required.
* `properties`: Map of property name → `ToolPropertyOverride` to modify parameters:
  * `type`: Override parameter type.
  * `description`: Change description of the parameter.
  * `x-ypipe-inject`: Dynamically inject a system property/variable value.
  * `x-ypipe-hidden`: Hide this property from the AI model (useful if it's injected).
