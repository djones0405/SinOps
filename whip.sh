#!/bin/bash

# --- CONFIG SECTION (customize as needed) ---
# Project or organization prefix
PREFIX="ahca"
# Base name for the app/script
BASE_NAME="base"
# Script extension
EXT="sh"
# Destination directory to watch
DEST_DIR="./scripts"

# --- Helper Functions ---

# Find the next version for base name and extension
find_next_version() {
    local pattern="${DEST_DIR}/${PREFIX}.${BASE_NAME}.v_*.${EXT}"
    local latest_ver=$(ls $pattern 2>/dev/null | grep -oP "v_\K[0-9]+" | sort -n | tail -1)
    if [[ -z "$latest_ver" ]]; then
        echo "01"
    else
        printf "%02d" $((latest_ver + 1))
    fi
}

# Build a compliant filename
build_filename() {
    local ver="$1"
    local is_bk="$2"
    local fname="${PREFIX}.${BASE_NAME}.v_${ver}.${EXT}"
    if [[ "$is_bk" == "true" ]]; then
        fname="${fname}.bk"
    fi
    echo "$fname"
}

# Check if filename matches the pattern
is_compliant_filename() {
    local fname=$(basename "$1")
    [[ "$fname" =~ ^${PREFIX}\.${BASE_NAME}\.v_[0-9]{2}\.${EXT}(\.bk)?$ ]]
}

# Rename file to compliant name and increment version if conflict
rename_file_compliant() {
    local src="$1"
    local is_bk="$2"
    local ver=$(find_next_version)
    local new_fname=$(build_filename "$ver" "$is_bk")
    local new_path="${DEST_DIR}/${new_fname}"
    if [[ "$src" == "$new_path" ]]; then
        # Already compliant
        return
    fi
    mv "$src" "$new_path"
    echo "Renamed $src -> $new_path"
}

# Create backup of latest script
backup_latest_script() {
    local pattern="${DEST_DIR}/${PREFIX}.${BASE_NAME}.v_*.${EXT}"
    local latest_file=$(ls $pattern 2>/dev/null | sort | tail -1)
    if [[ -n "$latest_file" ]]; then
        cp "$latest_file" "${latest_file}.bk"
        echo "Backup created: ${latest_file}.bk"
    fi
}

# --- Main Watcher Loop ---
echo "Watching $DEST_DIR for changes..."
inotifywait -m -e create -e moved_to -e modify "$DEST_DIR" --format '%w%f' |
while read FILE
do
    # Only process regular files
    [[ -f "$FILE" ]] || continue
    # If file is a backup (ends with .bk)
    if [[ "$FILE" =~ \.bk$ ]]; then
        is_bk="true"
    else
        is_bk="false"
    fi

    if ! is_compliant_filename "$FILE"; then
        rename_file_compliant "$FILE" "$is_bk"
    fi
done