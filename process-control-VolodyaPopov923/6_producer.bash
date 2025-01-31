#!/bin/bash

HANDLER_PID_FILE="/tmp/handler_pid"
if [[ ! -f $HANDLER_PID_FILE ]]; then
  echo "Ошибка: PID файла обработчика не найден!"
  exit 1
fi

HANDLER_PID=$(cat "$HANDLER_PID_FILE")

echo "Генератор запущен. Введите команды (+, *, TERM):"

while true; do
  read -p "> " input
  case "$input" in
    "+")
      kill -USR1 "$HANDLER_PID"
      ;;
    "*")
      kill -USR2 "$HANDLER_PID"
      ;;
    "TERM")
      kill -SIGTERM "$HANDLER_PID"
      echo "Генератор завершает работу."
      exit 0
      ;;
    *)
      echo "Игнорируется: $input"
      ;;
  esac
done
