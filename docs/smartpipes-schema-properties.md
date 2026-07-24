# YPipe SmartPipe Schema Properties

This document outlines the complete structural schema for a YPipe SmartPipe `.ypipe` manifest file. SmartPipes use a Kubernetes-style YAML declarative syntax to define complex AI agent workflows, DAGs (Directed Acyclic Graphs), triggers, and configuration metadata.

---

## 1. Root Manifest Structure

Every `.ypipe` file requires standard Kubernetes-style metadata wrappers.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `apiVersion` | String | The API schema version for this manifest. | `coordinator.ypipe.com/v1` |
| `kind` | String | The manifest kind. Must be `SmartPipe`. | `SmartPipe` |
| `metadata` | Object | Metadata grouping block. | *(See below)* |
| `spec` | Object | The primary specification block containing the logic. | *(See below)* |

### 1.1. `metadata` Block

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `name` | String | **Required.** The unique, URL-friendly identifier/slug for this flow. *Note: `metadata.name` + `metadata.namespace` must be strictly unique across the system.* | `customer-support-triage` |
| `namespace` | String | The tenant namespace this flow belongs to. Defaults to `default`. | `system` |
| `version` | String | Version tracking for the pipeline. | `1.0.0` |
| `author` | String | The author or owner of the pipeline. | `John Doe` |

---

## 2. The `spec` Block

The `spec` block contains the actual workflow logic, configurations, and step definitions.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `label` | String | **Required.** Human-readable display name for the flow. | `Support Ticket Triage` |
| `description` | String | Description of the flow's purpose. | `Categorizes support tickets.` |

| `inputs` | Map | Schema of expected inbound payload variables. | `ticket_subject: { type: "string" }` |
| `triggers` | List | Array of trigger configurations (HTTP Webhooks, Cron, etc.). | `[{ type: "http", path: "/triage" }]` |
| `secrets` | Map | Declared secrets required by this flow. | `api_key: { type: "env" }` |
| `knowledge` | Map | Bound vector knowledge bases or contextual memories. | *(Internal Map)* |
| `steps` | List | **Required.** Array of execution steps forming the DAG. | *(See Steps below)* |

---

## 3. Step Definitions

Steps in the `spec.steps` array define the actual execution nodes of the DAG. Every step shares a common set of base properties, and requires a `type` that dictates its specific functionality.

### 3.1. Common Step Properties (All Types)

These properties can be applied to **any** step regardless of its `type`.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `id` | String | **Required.** Unique node identifier within the DAG. | `extract_entities` |
| `type` | String | **Required.** The execution type of the step. | `inference` |
| `input` | String | The generic SpEL template or input string fed to the step. | `${inputs.ticket_body}` |
| `nocheckpoint`| Boolean | If true, the output of this step is not saved to history. | `false` |
| `exclude` | List | A list of string keys to strip/redact from the step's output map before it gets checkpointed to history. Very useful for hiding sensitive data or massive payloads from the database. | `["password", "raw_image"]` |
| `stateless` | Boolean | Controls conversational memory. By default (`false`), the step shares a continuous chat history with the entire flow. If `true`, the LLM starts with a completely fresh, isolated context window for this step. **Defaults to false.** | `true` |
| `runIf` | String | SpEL boolean condition evaluating if this step should run. | `${outputs.step_1.confidence > 0.8}` |
| `iterateOver` | String | SpEL expression resolving to an Array to execute this step in a loop. | `${outputs.list_generator}` |

---

### 3.2. Step-Specific Properties

Depending on the `type` specified, the step requires or supports additional configuration properties.

#### `inference` (LLM/Vision Execution)
Executes a prompt against an AI model.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `model` | String | The YPipe model identifier to use, typically formatted as `namespace/model_id` or just the global `model_id`. | `default-gpt-4o` |
| `parameters` | Map | Generation constraints (temperature, tokens, etc.). | `temperature: 0.2` |
| `prompts.system` | String | The system prompt template. | `You are a helpful assistant.` |
| `prompts.user` | String/Object | The user prompt template or structured JSON input. | `Summarize this: ${input}` |
| `abilities` | List | Specific MCP tool abilities granted to this inference step. | `[ { name: "search_web" } ]` |

#### `javascript` (Code Execution)
Executes a raw server-side Javascript snippet.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `script` | String | The JS code to execute. Can mutate the context state. | `return input.toUpperCase();` |

#### `file_writer` (Write File to Disk)
Writes the evaluated `input` property into a local file.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `filePath` | String | Absolute or relative path to the destination file. | `/tmp/output.txt` |
| `append` | Boolean | If true, appends to the file instead of overwriting. | `true` |

#### `file_reader` (Read File from Disk)
Reads content from a local file and loads it into the state.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `filePath` | String | Absolute or relative path to the source file. | `/tmp/data.csv` |
| `targetVariable` | String | The context variable to assign the file contents to. | `file_data` |
| `isPicture` | Boolean | Read the file as a base64 encoded image for VLM. | `false` |

#### `http_caller` (Webhook/API Call)
Triggers a REST API call. *(Note: Standard HTTP headers and body properties are planned for future expansions).*

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `url` | String | The destination URL to invoke. | `https://api.example.com/data` |
| `method` | String | The HTTP Method to use. | `POST`, `GET` |

#### `output_page_sink` (Web Page Generation)
Creates a human-readable web UI rendering the pipeline results.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `generateWebInterface`| Boolean| If true, auto-generates a standard web UI for the output. | `true` |
| `useCallback` | Boolean | Whether to trigger an asynchronous callback on completion. | `false` |
| `callbackUrl` | String | The webhook URL to hit upon completion. | `https://.../callback` |
| `titlePicture` | String | Image URL for the generated page header. | `/images/hero.png` |
| `useCustomHtml`| Boolean | If true, uses the provided raw HTML string instead of standard UI.| `false` |
| `customHtml` | String | Raw HTML template to render the output state. | `<h1>${outputs.summary}</h1>` |

#### `human_interaction_gate` (Human-in-the-Loop)
Pauses execution and sends an interactive form to a human operator for input before resuming.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `allowPictureUpload` | Boolean | Whether the human user can attach an image. | `true` |
| `customFormFields` | List | Array defining the form schema (`name`, `type`, `label`). | `[{name: "approval", type: "boolean"}]` |

#### `context_memory_sink` (Vector/Memory Sink)
Stores the output result into a Long-Term Vector Memory collection.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `memoryCollectionId` | String | The ID of the Vector Memory collection to write to. | `support_kb` |

#### `input_required` (Blocking Request)
Asserts that a specific user message or payload is present.

| Property | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `userMessage` | String | The prompt shown if the required input is missing. | `Please provide your ID.` |

---

## Example SmartPipe YAML

```yaml
apiVersion: "coordinator.ypipe.com/v1"
kind: SmartPipe
metadata:
  name: "ticket-triage"
  namespace: "system"
spec:
  name: "Ticket Triage"
  description: "Categorize inbound tickets"

  triggers:
    - type: "http"
      method: "POST"
      path: "/api/triage"
  steps:
    - id: "analyze_sentiment"
      type: "inference"
      model: "llama3-8b"
      input: "${inputs.ticket_body}"
      prompts:
        system: "You categorize support tickets. Return JSON."
    - id: "notify_slack"
      type: "http_caller"
      runIf: "${outputs.analyze_sentiment.urgency == 'HIGH'}"
      url: "https://hooks.slack.com/services/..."
      method: "POST"
```
