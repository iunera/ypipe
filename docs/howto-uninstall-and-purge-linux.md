# How to Uninstall & Purge YPipe (Debian / Ubuntu)

This guide explains how to uninstall and purge YPipe when installed via Debian packages (`.deb` / `dpkg` / `apt`).

---

## 1. Quick Comparison: Uninstall vs. Purge

| Action | Command | What gets removed | What is preserved |
| :--- | :--- | :--- | :--- |
| **Uninstall (Remove)** | `sudo apt remove ypipe`<br>*(or `sudo dpkg -r ypipe`)* | Application binaries (`/opt/ypipe`), launcher link (`/usr/bin/ypipe`), desktop launcher menu entry | User models, downloaded runtimes, database stores, configs in `~/.ypipe` |
| **Purge (Clean Sweep)** | `sudo apt purge ypipe`<br>*(or `sudo dpkg -P ypipe`)* | Application binaries, desktop entry, **and all user data** (`~/.ypipe` across `/home/*` and `/root/.ypipe`) | *Nothing* — full reset |

---

## 2. Option A: Standard Uninstall (Keep Configurations & Models)

If you plan to reinstall YPipe later or want to keep your downloaded LLMs, vector embeddings, and pipelines intact, perform a standard removal:

### Using APT (Recommended)
```bash
sudo apt remove ypipe
```

### Using DPKG
```bash
sudo dpkg -r ypipe
```

### What this does:
* Removes `/opt/ypipe` binaries and bundled Java runtime.
* Removes `/usr/bin/ypipe` CLI shortcut.
* Removes `/usr/share/applications/ypipe-ypipe.desktop` from the Ubuntu "Show Applications" menu.
* **Keeps** `~/.ypipe/` containing:
  * Downloaded models (`~/.ypipe/models`)
  * Runtime dependencies (`~/.ypipe/runtimes`)
  * Local KnowledgePipe stores and configuration databases (`~/.ypipe/h2`, `~/.ypipe/config`)

---

## 3. Option B: Full Purge (Complete Removal Including All Data)

> [!WARNING]
> Purging YPipe deletes all models, runtime binaries, vector indices, and user configurations located in `~/.ypipe` for all users on the machine. This cannot be undone.

### Using APT (Recommended)
```bash
sudo apt purge ypipe
```

### Using DPKG
```bash
sudo dpkg -P ypipe
```

### If YPipe was already uninstalled with `apt remove`:
```bash
sudo apt purge ypipe
```
*(This triggers the package's `postrm purge` cleanup script.)*

---

## 4. Manual Post-Removal Verification & Cleanup

To verify all components were completely removed:

### 1. Verify dpkg Status
```bash
dpkg -l | grep ypipe
```
* **No output**: Successfully purged.
* **`rc  ypipe ...`**: The package was removed, but residual configuration / purge pending. Run `sudo dpkg -P ypipe` to finish.
* **`ii  ypipe ...`**: The package is still installed.

### 2. Verify Application Shortcut Cleanup
```bash
ls -la /usr/share/applications/ypipe*.desktop 2>/dev/null
ls -la /usr/bin/ypipe 2>/dev/null
```
If any desktop entry remains cached in GNOME / Ubuntu Dash:
```bash
sudo update-desktop-database /usr/share/applications
```

### 3. Verify Data Directory Removal (If Purged)
```bash
ls -la ~/.ypipe
```
If you performed a manual uninstall rather than a purge and decide you want to remove the data directory manually:
```bash
rm -rf ~/.ypipe
```
