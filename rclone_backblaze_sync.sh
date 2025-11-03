#!/usr/bin/env bash

set -euo pipefail

if [ -z "${SOURCE_DIR:-}" ] && [ -z "${REMOTE_PATH:-}" ]; then
    echo "ERROR: SOURCE_DIR and REMOTE_PATH must be set" >&2
    exit 1
fi

RCLONE_OPTS=(
    "--checksum"
    "--human-readable"
    "--exclude=.stfolder/*"
    "--exclude=.stversions/*"
    "--config=${HOME}/.config/rclone/rclone.conf"
    "--log-file=${HOME}/.local/var/log/rclone/rclone-sync.log"
    "--log-file-max-size=10M"
    "--log-level=INFO"
    "--use-json-log"
)

rclone sync "${RCLONE_OPTS[@]}" "$SOURCE_DIR" "$REMOTE_PATH"