#!/bin/bash

HOME_DIR="$HOME"

TEST_DIR="$HOME_DIR/test"
ARCHIVED_DIR="$TEST_DIR/archived"
mkdir -p "$TEST_DIR"
mkdir -p "$ARCHIVED_DIR"

CURRENT_DATE=$(date +"%Y-%m-%d")
CURRENT_TIME=$(date +"%H:%M:%S")
CURRENT_DATETIME="${CURRENT_DATE}_${CURRENT_TIME}"

NEW_FILE="$TEST_DIR/$CURRENT_DATETIME"


FILES_TO_ARCHIVE=$(find "$TEST_DIR" -maxdepth 1 -type f -name "$CURRENT_DATE_*")

if [ -n "$FILES_TO_ARCHIVE" ]; then
  ARCHIVE_NAME="$ARCHIVED_DIR/$CURRENT_DATE.tar.gz"
  tar -czf "$ARCHIVE_NAME" $FILES_TO_ARCHIVE && rm $FILES_TO_ARCHIVE
fi

touch "$NEW_FILE"

REPORT_FILE="$HOME_DIR/report"
echo "$(date +"%Y-%m-%d %H:%M:%S") test was created successfully" >> "$REPORT_FILE"

echo "Скрипт выполнен успешно."
