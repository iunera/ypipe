# Running YPipe in Headless Mode

YPipe can run completely headlessly without launching the JavaFX GUI. This is ideal for server environments, Docker containers, CI/CD pipelines, or background daemons.

---

## 1. Quick Start Methods

You can configure and start headless mode using either **command-line arguments** or **environment variables**.

### Method A: Command-Line Arguments
Pass the configuration directly to the launcher:
```bash
ypipe --headless \
      --ypipe.data=/Users/chris/.ypipeheadless \
      --ypipe.autodownload=true \
      --ypipe.coordinator.llm.models.active.tasks.chat.model=system/qwen-3p5-text-only-bs-0p8b
```

### Method B: Environment Variables (`.env`)
Export the environment variables (e.g., using a `.env` file or container environment) before starting:
```env
# Enable headless startup
YPIPE_HEADLESS=true

# Custom data directory location
YPIPE_DATA=/Users/chris/.ypipeenv

# Automatically download missing runtimes and models on startup
YPIPE_AUTODOWNLOAD=true
```

Simply start the application with no arguments:
```bash
ypipe
```

---

## 2. Advanced Configuration Mapping

Spring Boot automatically translates environment variables to property keys using standard relaxed binding rules:

| Command-Line Property | Environment Variable | Role                                                                                                       |
| --- | --- |------------------------------------------------------------------------------------------------------------|
| `--headless` | `YPIPE_HEADLESS=true` | Bypasses JavaFX UI startup.                                                                                |
| `--ypipe.data` | `YPIPE_DATA` | Configures the central storage directory.                                                                  |
| `--ypipe.autodownload=true` | `YPIPE_AUTODOWNLOAD=true` | Downloads missing runtimes/models on startup.                                                              |
| `--ypipe.coordinator.llm.models.active.tasks.chat.model` | `YPIPE_COORDINATOR_LLM_MODELS_ACTIVE_TASKS_CHAT_MODEL` | Sets the default active model.                                                                             |
| `--ypipe.coordinator.llm.models.active.tasks.chat.startup` | `YPIPE_COORDINATOR_LLM_MODELS_ACTIVE_TASKS_CHAT_STARTUP` | Configures model startup boot mode (`LAZY`, `EAGER`, `MANUAL`).                                            |
| `--ypipe.engine.llm.runtimes.active.variant` | `YPIPE_ENGINE_LLM_RUNTIMES_ACTIVE_VARIANT` | Sets active llama.cpp runtime variant.                                                                     |
| `--ypipe.engine.llm.runtimes.active.build` | `YPIPE_ENGINE_LLM_RUNTIMES_ACTIVE_BUILD` | Sets active llama.cpp runtime build version.                                                               |
| `--ypipe.coordinator.llm.runtimes.llamacpp.download-sources.build.lamacpp` | `YPIPE_COORDINATOR_LLM_RUNTIMES_LLAMACPP_DOWNLOAD_SOURCES_BUILD_LAMACPP` | (Optional) Overrides build version in standard Runtimes Catalog. In autodownload mode is `YPIPE_ENGINE_LLM_RUNTIMES_ACTIVE_BUILD` used by default |
| `--ypipe.coordinator.llm.runtimes.llamacpp.download-sources.build.lemonade-sdk` | `YPIPE_COORDINATOR_LLM_RUNTIMES_LLAMACPP_DOWNLOAD_SOURCES_BUILD_LEMONADE_SDK` | (Optional) Overrides build version in AMD ROCm catalog.                                                    |

---

## 3. Auto-Download on Vanilla Systems

When `autodownload` is enabled in headless mode, the system follows a **Self-Provisioning sequence** on startup:

1. **Directories Creation:** Pre-creates the entire folder structure under the designated data path (`ypipe.data`).
2. **Runtime Acquisition:** Resolves the specified runtime variant/build. If missing from the `ready/` directory, the launcher downloads and extracts the archive before proceeding.
3. **Model Acquisition:** Resolves the active primary chat model. If its GGUF weights are missing, the launcher downloads the file from Hugging Face (retrieved from the workspace or system catalogs).
4. **Boot:** The launcher holds context start until both downloads are complete and then successfully boots the headless services.

### Custom Runtime Releases (Dynamic Registration)

If you need a specific custom release of `llama.cpp` (e.g., a newer release like `b9999`) that is not pre-packaged or hardcoded in the static catalog, you can configure it directly:

```env
YPIPE_ENGINE_LLM_RUNTIMES_ACTIVE_VARIANT=MACOS_ARM64_CPU_METAL
YPIPE_ENGINE_LLM_RUNTIMES_ACTIVE_BUILD=b9999
```

When `YPIPE_AUTODOWNLOAD=true` is enabled:
* The bootstrapper automatically detects that the custom build is not pre-registered.
* It dynamically resolves the correct download URLs using the catalog's template format (mapping the target CPU/GPU variant to release assets on `ggml-org/llama.cpp` or ROCm releases from `lemonade-sdk/llamacpp-rocm`).
* The custom runtime is registered on-the-fly, downloaded, and extracted into `{ypipe.data}/runtimes/ready/{variant}/{build}` automatically.
* You do **not** need to modify properties or configure custom download source URLs. Setting environment variables such as `YPIPE_COORDINATOR_LLM_RUNTIMES_LLAMACPP_DOWNLOAD_SOURCES_BUILD_LAMACPP` or `YPIPE_COORDINATOR_LLM_RUNTIMES_LLAMACPP_DOWNLOAD_SOURCES_BUILD_LEMONADE_SDK` is entirely optional, as the system dynamically registers target builds on-demand.

---
 
## 4. Manual Provisioning

If you are running in restricted, firewalled, or completely offline environments where `YPIPE_AUTODOWNLOAD=false` is desired, you can manually provision the required resources within your designated `YPIPE_DATA` directory.

To manually set up your workspace:

### A. Define and Create your Data Directory
Create your base directory (e.g., `/path/to/my-ypipe-data`) and point YPipe to it:
```bash
export YPIPE_DATA=/path/to/my-ypipe-data
mkdir -p $YPIPE_DATA
```

### B. Manual Model Setup
Place your GGUF model files directly under `{YPIPE_DATA}/models/gguf/`:
```bash
mkdir -p $YPIPE_DATA/models/gguf
# Copy your GGUF files here, e.g.:
# cp ax_ggml-org_qwen_3.5_0.8b_it_q4km.gguf $YPIPE_DATA/models/gguf/
```

> [!IMPORTANT]
> When manually placing GGUF files, the filename must exactly match the filename specified in the model's `.ypipe` manifest file located under your workspace repository (e.g., `{YPIPE_DATA}/workspace/repos/<namespace>/<model-name>.ypipe`).

### C. Manual Runtime Setup
Place your compiled or pre-built `llama.cpp` runtime binaries inside the `{YPIPE_DATA}/runtimes/ready/{variant}/{build}/` folder hierarchy.
1. Create the variant/build directory structure matching your target architecture (e.g., `MACOS_ARM64_CPU_METAL` with build `b9999`):
   ```bash
   mkdir -p $YPIPE_DATA/runtimes/ready/MACOS_ARM64_CPU_METAL/b9999
   ```
2. Extract the `llama.cpp` binary and library files directly into that directory.
3. Configure the active environment variables to lock onto your manually provisioned runtime:
   ```env
   YPIPE_ENGINE_LLM_RUNTIMES_ACTIVE_VARIANT=MACOS_ARM64_CPU_METAL
   YPIPE_ENGINE_LLM_RUNTIMES_ACTIVE_BUILD=b9999
   ```

### D. Manual Workspace Setup
If you are deploying custom [Models](https://github.com/iunera/ypipe/tree/main/Models), [MCP Integration Blueprints](https://github.com/iunera/ypipe/tree/main/McpIntegrationBlueprints) (see the [Blueprints README](https://github.com/iunera/ypipe/blob/main/McpIntegrationBlueprints/README-McpIntegrationBlueprints.md) for details), or agent/tool definitions, you must provision the workspace repository directory:
1. Create the workspace repos directory:
   ```bash
   mkdir -p $YPIPE_DATA/workspace/repos
   ```
2. You can copy-paste your entire `workspace/repos` directory from your local development machine, version control, or downloaded from the official repository folders ([Models](https://github.com/iunera/ypipe/tree/main/Models) / [MCP Integration Blueprints](https://github.com/iunera/ypipe/tree/main/McpIntegrationBlueprints)) directly into `$YPIPE_DATA/workspace/repos/`. YPipe will scan and load these manifests on boot.

---

## 5. Deploying Custom Models (Non-Catalog)

If you are using custom models that are not part of the standard catalog, you must provide a local manifest definition so the self-provisioning bootstrapper knows where to download the weights.

To do this, place a `.ypipe` model manifest file under your workspace repository folder:
`{ypipe.data}/workspace/repos/<namespace>/<model-name>.ypipe`

Example file path:
`~/.ypipe/workspace/repos/custom-models/my-custom-model.ypipe`

The manifest should define the Hugging Face download URL (or other source locations) for the model's GGUF file. Once defined, you can set the model key:
`--ypipe.coordinator.llm.models.active.tasks.chat.model=custom-models/my-custom-model`

---

## 6. Portable Deployments ("Copy-Paste")

YPipe is built with **portable design principles**. All runtimes, configurations, downloaded models, and agent drafts are fully self-contained inside the directory specified by `ypipe.data` (defaulting to `~/.ypipe`).

To migrate or clone your setup to a new server or offline environment:
1. **Copy the data directory:** Zip or copy the entire `ypipe.data` directory from your local development machine.
2. **Transfer to target:** Place it on the target server (e.g., at `/home/ubuntu/.ypipe`).
3. **Run from target:** Start the launcher pointing to that directory.
4. **Self-Healing on Target:** If the hardware architecture on the target server differs (e.g., you built or ran on Apple Silicon locally, but deploy to a Linux server with an Nvidia GPU), simply set `--ypipe.autodownload=true`. The system will automatically detect the new hardware, download the correct optimized llama.cpp runtime variant, and boot using the existing local GGUF models.
