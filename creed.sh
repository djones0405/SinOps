#!/bin/bash

# ==== SinOps Master Config ====

# === User Configurable Section ===
PREFIX="ahca"
BASE_NAME="base"
EXT="sh"
DEST_DIR="./scripts"          # Where project folders live
BACKUP_SUBDIR=".bk"           # Inside each project folder
LOG_DIR="./logs"
LOG_FILE="${LOG_DIR}/sinops.log"
TIMEZONE="America/New_York"
LOG_LEVEL="DEBUG"
TIMESTAMP_FORMAT="%m-%d-%Y %H:%M:%S"
COMMAND_TRACING=true

# === Helper Functions ===

find_next_version() {
    local pattern="${DEST_DIR}/${BASE_NAME}/${PREFIX}.${BASE_NAME}.v_*.${EXT}"
    local latest_ver=$(ls $pattern 2>/dev/null | grep -oP "v_\K[0-9]+" | sort -n | tail -1)
    if [[ -z "$latest_ver" ]]; then
        echo "01"
    else
        printf "%02d" $((latest_ver + 1))
    fi
}

build_filename() {
    local ver="$1"
    local is_bk="$2"
    local fname="${PREFIX}.${BASE_NAME}.v_${ver}.${EXT}"
    [[ "$is_bk" == "true" ]] && fname="${fname}.bk"
    echo "$fname"
}

get_project_dir() {
    echo "${DEST_DIR}/${BASE_NAME}"
}

get_backup_dir() {
    echo "${DEST_DIR}/${BASE_NAME}/${BACKUP_SUBDIR}"
}

ensure_project_dir() {
    [[ -d "$(get_project_dir)" ]] || mkdir -p "$(get_project_dir)"
}

ensure_backup_dir() {
    [[ -d "$(get_backup_dir)" ]] || mkdir -p "$(get_backup_dir)"
}

ensure_log_dir() {
    [[ -d "$LOG_DIR" ]] || mkdir -p "$LOG_DIR"
}

log_event() {
    local level="$1"
    shift
    local msg="$*"
    local ts=$(TZ="$TIMEZONE" date +"$TIMESTAMP_FORMAT")
    echo "$ts [$level] [${BASH_SOURCE[1]}] $msg" >> "$LOG_FILE"
}

backup_latest_script() {
    ensure_backup_dir
    local pattern="$(get_project_dir)/${PREFIX}.${BASE_NAME}.v_*.${EXT}"
    local latest_file=$(ls $pattern 2>/dev/null | sort | tail -1)
    if [[ -n "$latest_file" ]]; then
        local backup_path="$(get_backup_dir)/$(basename "$latest_file").bk"
        cp "$latest_file" "$backup_path"
        log_event "INFO" "Backup created: $backup_path"
        echo "Backup created: $backup_path"
    fi
}

# Create new script (auto-versioned)
create_new_script() {
    ensure_project_dir
    ensure_log_dir
    local ver=$(find_next_version)
    local fname=$(build_filename "$ver" "false")
    local fullpath="$(get_project_dir)/$fname"
    touch "$fullpath"
    log_event "INFO" "Created script: $fullpath"
    echo "Created: $fullpath"
    backup_latest_script
}

# Enforce that a file is in the right folder and named correctly
enforce_file_location_and_name() {
    local file="$1"
    local fname=$(basename "$file")
    local ext="${fname##*.}"
    local expect_dir="$(get_project_dir)"
    local file_dir=$(dirname "$file")

    if [[ "$file_dir" != "$expect_dir" ]]; then
        read -p "Move $fname to $expect_dir/? [Y/n]: " resp
        resp=${resp:-Y}
        if [[ "$resp" =~ ^[Yy]$ ]]; then
            mv "$file" "$expect_dir/"
            log_event "INFO" "Moved $fname to $expect_dir/"
            echo "Moved $fname to $expect_dir/"
        else
            log_event "WARN" "User declined to move $fname to $expect_dir/"
        fi
    fi
}

# Usage: source this config in your watcher or other scripts.