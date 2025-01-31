#!/usr/bin/env bash

TRASH_PATH="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

MODE="--ignore"

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--ignore)
            MODE="--ignore"
            shift
            ;;
        -u|--unique)
            MODE="--unique"
            shift
            ;;
        -o|--overwrite)
            MODE="--overwrite"
            shift
            ;;
        *)
            break
            ;;
    esac
done

while read -r entry; do
    if [[ "$entry" == *" RESTORED" ]]; then
        continue
    fi
    ORIGINAL_PATH=$(cut -d' ' -f2- <<< "$entry")
    if [ -n "$(basename "$ORIGINAL_PATH" | grep "$1")" ]; then
        read -u 3 -p "Restore $ORIGINAL_PATH?[y/n] " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if [ ! -d "$(dirname "$ORIGINAL_PATH")" ]; then
                RESTORE_DIRECTORY=$HOME
            else
                RESTORE_DIRECTORY=$(dirname "$ORIGINAL_PATH")
            fi
            RESTORE_PATH=$RESTORE_DIRECTORY/$(basename "$ORIGINAL_PATH")
            case $MODE in
                --ignore)
                    if [ -f "$RESTORE_PATH" ]; then
                        echo "Cannot restore $ORIGINAL_PATH: file already exists."
                        continue
                    fi
                    ;;
                --unique)
                    if [ -f "$RESTORE_PATH" ]; then
                        BASENAME=$(basename "$ORIGINAL_PATH" | sed 's/\.[^.]*$//')
                        EXTENSION=$(basename "$ORIGINAL_PATH" | grep -oE '\.[^.]+$')
                        COUNTER=1
                        while [ -f "$RESTORE_DIRECTORY/$BASENAME($COUNTER)$EXTENSION" ]; do
                            ((COUNTER++))
                        done
                        RESTORE_PATH="$RESTORE_DIRECTORY/$BASENAME($COUNTER)$EXTENSION"
                    fi
                    ;;
                --overwrite)
                    ;;
            esac
            
            TRASH_FILE_PATH=$TRASH_PATH/$(cut -d' ' -f1 <<< "$entry")
            ln "$TRASH_FILE_PATH" "$RESTORE_PATH"
            rm "$TRASH_FILE_PATH"
            sed -i "s|^$entry$|$entry RESTORED|" "$TRASH_LOG"
        fi
    fi
done 3<&0 < "$TRASH_LOG"
