#!/bin/bash

TRASH_PATH="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

if [ ! -d "$TRASH_PATH" ]; then
    if [ -f "$TRASH_PATH" ]; then
        >&2 echo "'$TRASH_PATH' is a file, should be a directory"
        exit 1
    fi
    mkdir "$TRASH_PATH"
fi

if [ ! -f "$1" ]; then
    >&2 echo "File '$1' not found"
    exit 1
fi

if [ -z "$(ls "$TRASH_PATH")" ]; then
    NEXT_FILE_ID=0
else
    NEXT_FILE_ID=$(($(ls "$TRASH_PATH" | sort | tail -n1) + 1))
fi

ln "$1" "$TRASH_PATH/$NEXT_FILE_ID"
rm "$1"

echo "$NEXT_FILE_ID" "$1" >> "$TRASH_LOG"
