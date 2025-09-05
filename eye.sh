#!/bin/bash

# Requires: inotify-tools (install with: sudo apt-get install inotify-tools)

WATCH_DIR="./scripts"
CONFIG="./script_repo_config.sh"

# Load config
source "$CONFIG"

# Watch for create/move/modify events in the scripts directory
inotifywait -m -e create -e moved_to -e modify "$WATCH_DIR" --format '%w%f' |
while read FILE
do
    echo "Detected change: $FILE"
    # Call enforcement functions (e.g., check naming, version, backup)
    # For example:
    # enforce_naming "$FILE"
    # enforce_version "$FILE"
    # Optionally move, rename, or back up files as needed
done