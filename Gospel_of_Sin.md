# SinOps Script Management System

## Overview

**SinOps** is a modular system for organized, versioned, and traceable script/config management. It enforces naming conventions, automatic project directory creation, backup management, and detailed logging with configurable settings. The system is composed of three main scripts:

- `script_repo_config.sh` – Master configuration and utility functions
- `eye.sh` – Watcher daemon for real-time enforcement and backup
- `whip.sh` – Manual compliance and cleanup tool

---

## Features

- **Enforced Naming Convention:**  
  Scripts must be named as `PREFIX.BASE_NAME.v_##.EXT` (e.g., `ahca.base.v_01.sh`).

- **Project Root Folder Structure:**  
  Each `BASE_NAME` has its own folder (`./scripts/base/`), ensuring project isolation.

- **Automatic Directory Management:**  
  If the required project or backup directory does not exist, it is created automatically.

- **Automatic Backup:**  
  Every time a script is created or modified, the latest version is backed up to `./scripts/base/.bk/`.

- **Centralized, Configurable Logging:**  
  Detailed logs in `./logs/sinops.log` with severity levels, EST timestamps, and command tracing. All logging options and locations are configurable.

- **Interactive Correction:**  
  When a script is saved outside its project folder, the system offers to move and organize it properly.

- **Manual Compliance Enforcement:**  
  Run `whip.sh` to scan for out-of-place or non-compliant scripts and fix them.

---

## Directory Structure

```
repo-root/
├── scripts/
│   └── base/
│       ├── ahca.base.v_01.sh
│       ├── ahca.base.v_02.sh
│       └── .bk/
│           ├── ahca.base.v_01.sh.bk
│           └── ahca.base.v_02.sh.bk
├── logs/
│   └── sinops.log
├── script_repo_config.sh
├── eye.sh
├── whip.sh
└── README.md
```

---

## Configuration (`script_repo_config.sh`)

Edit the variables in the "User Configurable Section" at the top:

```bash
PREFIX="ahca"                # Organization/project prefix
BASE_NAME="base"             # Logical project name
EXT="sh"                     # File extension for scripts
DEST_DIR="./scripts"         # Where project folders are created
BACKUP_SUBDIR=".bk"          # Backup folder inside each project
LOG_DIR="./logs"             # Where logs are stored
LOG_FILE="${LOG_DIR}/sinops.log"
TIMEZONE="America/New_York"  # Log timestamps in EST/EDT (NYC)
LOG_LEVEL="DEBUG"            # Logging level (DEBUG/INFO/WARN/ERROR)
TIMESTAMP_FORMAT="%m-%d-%Y %H:%M:%S"
COMMAND_TRACING=true         # Trace commands in logs
```

---

## How It Works

### 1. **Watcher (`eye.sh`)**

- Watches the `DEST_DIR` for new or modified scripts matching your configured extension.
- Enforces that scripts:
  - Use proper naming/version convention
  - Are inside the correct project folder
  - Are automatically backed up to their `.bk/` folder on change
- If a script is outside its project folder, you are prompted to move it.

### 2. **Manual Compliance (`whip.sh`)**

- Scans the entire `DEST_DIR` for non-compliant scripts.
- Offers to move and organize files as needed.
- Triggers backup as appropriate.

### 3. **Config/Logic (`script_repo_config.sh`)**

- All utility functions (directory creation, naming, versioning, logging, backup) are here.
- Both watcher and whip source this file, making all logic and config centralized and reusable.

---

## Logging

- All actions are logged with:
  - Severity level (`DEBUG`, `INFO`, `WARN`, `ERROR`)
  - Script name and message
  - Timestamp in EST (NYC)
- Log location, format, level, and timezone are configurable.
- Example log entry:

  ```
  09-04-2025 22:15:11 [INFO] [eye.sh] Created script: ./scripts/base/ahca.base.v_03.sh
  09-04-2025 22:15:12 [INFO] [eye.sh] Backup created: ./scripts/base/.bk/ahca.base.v_03.sh.bk
  ```

---

## Usage

### 1. **Initialize the System**

```bash
chmod +x script_repo_config.sh eye.sh whip.sh
mkdir -p scripts logs
```

### 2. **Start the Watcher**

```bash
./eye.sh
```

- Leave this running in a terminal for real-time enforcement and backup.

### 3. **Create New Scripts**

Use the `create_new_script` function from the config for versioned creation:

```bash
source ./script_repo_config.sh
create_new_script
```

### 4. **Manual Compliance Check**

To scan and correct your repo:

```bash
./whip.sh
```

---

## Advanced: Changing Project/Script Config

To manage multiple projects or script types, edit `BASE_NAME`, `EXT`, and `PREFIX` in `script_repo_config.sh` and restart your watcher.

---

## Requirements

- `bash`
- `inotify-tools` (for real-time watcher; install via `sudo apt-get install inotify-tools`)
- Standard GNU utilities (`ls`, `sort`, `cp`, `mv`, etc.)

---

## Troubleshooting

- **Watcher not responding:** Ensure `inotify-tools` is installed and the watcher is pointed to the correct `DEST_DIR`.
- **Logs missing:** Make sure `LOG_DIR` exists and is writable.
- **Backups not being created:** Confirm your scripts are named correctly and reside in their project folder.

---

## Author

Created by Danny <Danny.jones4588@gmail.com>

---