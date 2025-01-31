#!/bin/bash

FIFO="/tmp/my_fifo"

echo "Введите команды ('QUIT' для выхода):"

while true; do
  read -p "> " command
  echo "$command" > "$FIFO"
  
done
