#!/usr/bin/env bash

# Back up KeePass database to Backblaze B2 using rclone.

set -euo pipefail

KEEPASS_DIR="${HOME}/.keepass/"
REMOTE_PATH="keepass:${BUCKET_NAME}/"

RCLONE_OPTS=(
    "--checksum"
    "--human-readable"
    "--exclude=.stfolder/*"
    "--config=${HOME}/.config/rclone/rclone.conf"
    "--log-file=${HOME}/.local/var/log/rclone/keepass.log"
    "--log-file-max-size=10M"
    "--log-level=INFO"
    "--use-json-log"
)

rclone copy "${RCLONE_OPTS[@]}" "$KEEPASS_DIR" "$REMOTE_PATH"