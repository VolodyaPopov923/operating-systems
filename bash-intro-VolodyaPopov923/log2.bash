#!/bin/bash

LOG_FILE="/var/log/Xorg.0.log"
OUTPUT_FILE="X_info_warn.log"

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Файл $LOG_FILE не найден."
    exit 1
fi

grep '(WW)' "$LOG_FILE" | sed 's/(WW)/Warning:/' > "$OUTPUT_FILE"

grep '(II)' "$LOG_FILE" | sed 's/(II)/Information:/' >> "$OUTPUT_FILE"

cat "$OUTPUT_FILE"
