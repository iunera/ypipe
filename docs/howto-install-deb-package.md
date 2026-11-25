# How-To: Installing YPipe on Debian / Ubuntu via `dpkg`

This guide explains how to install the YPipe `.deb` package using `dpkg`, understand how dependency resolution works with `dpkg`, and resolve missing dependency errors.

---

## 1. Installing with `dpkg`

To install the `.deb` package on Debian or Ubuntu:

```bash
# For standard Intel / AMD 64-bit systems (x64 / amd64)
sudo dpkg -i ypipe_2.0.0_amd64.deb

# For ARM64 systems (e.g. Raspberry Pi 5, Azure ARM64, Ampere, Apple Silicon Linux VM — v2.0.0+)
sudo dpkg -i ypipe_2.0.0_arm64.deb
```

---

## 2. Resolving Missing Dependency Errors

### The Issue:
Because `dpkg` is a low-level package manager, it only unpacks and attempts to configure the package. It **does not download missing dependencies** from online repositories. 

If required graphical, web, or audio libraries (such as GTK, Cairo, ALSA, X11, or Wayland) are not already installed on the system, `dpkg` will output errors similar to:

```text
dpkg: dependency problems prevent configuration of ypipe:
 ypipe depends on libasound2t64 | libasound2; however:
  Package libasound2t64 is not installed.
  Package libasound2 is not installed.
 ypipe depends on libgtk-3-0t64 | libgtk-3-0; however:
  Package libgtk-3-0t64 is not installed.
  Package libgtk-3-0 is not installed.
 ...
dpkg: error processing package ypipe (--install):
 dependency problems - leaving unconfigured
Errors were encountered while processing:
 ypipe
```

### The Fix:
Tell the system package manager (`apt`) to resolve and install the missing dependencies that `dpkg` flagged:

```bash
sudo apt-get install -f -y
```

This single command:
1. Detects that `ypipe` is unpacked but unconfigured due to missing dependencies.
2. Downloads and installs all missing prerequisite packages from your configured Debian/Ubuntu mirrors.
3. Automatically finishes configuring `ypipe`.
