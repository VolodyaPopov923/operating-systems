#!/bin/bash

BACKUP_DIR_BASE="$HOME"
RESTORE_DIR="$BACKUP_DIR_BASE/restore"

mkdir -p "$RESTORE_DIR"

latest_backup=""
latest_date=0

for dir in "$BACKUP_DIR_BASE"/Backup-*; do
  if [ -d "$dir" ]; then
    dir_date=$(basename "$dir" | cut -d'-' -f2-)
    dir_timestamp=$(date -d "$dir_date" +%s 2>/dev/null || echo 0)
    if (( dir_timestamp > latest_date )); then
      latest_date=$dir_timestamp
      latest_backup="$dir"
    fi
  fi
done

if [ -z "$latest_backup" ]; then
  echo "No backup directories found. Exiting." >&2
  exit 1
fi

find "$latest_backup" -type f ! -name "*.[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]" | while IFS= read -r file; do
  relative_path="${file#$latest_backup/}"
  target_file="$RESTORE_DIR/$relative_path"
  target_dir=$(dirname "$target_file")
  mkdir -p "$target_dir"
  cp "$file" "$target_file"
  echo "Restored $file to $target_file"
done
