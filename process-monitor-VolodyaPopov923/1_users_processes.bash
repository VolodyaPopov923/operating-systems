#!/bin/bash
process_count=$(ps -u "$USER" --no-headers | wc -l)

echo "$process_count" > process_info.txt

ps -u "$USER" -o pid,cmd --no-headers | awk '{print $1 ":" $2}' >> process_info.txt
