#!/bin/bash

HANDLER_PID_FILE="/tmp/handler_pid"
if [[ ! -f $HANDLER_PID_FILE ]]; then
  echo "Ошибка: PID файла обработчика не найден!"
  exit 1
fi

HANDLER_PID=$(cat "$HANDLER_PID_FILE")

echo "Генератор запущен. Введите число от 1 до 100 или команды (SHOW, QUIT):"

while true; do
  read -p "> " input
  case "$input" in
    [0-9]*)
      GUESS=$input
      export GUESS
      kill -USR1 "$HANDLER_PID"
      ;;
    "SHOW")
      kill -USR2 "$HANDLER_PID"
      ;;
    "QUIT")
      kill -SIGTERM "$HANDLER_PID"
      echo "Генератор завершает работу."
      exit 0
      ;;
    *)
      echo "Неверный ввод: $input"
      ;;
  esac
done
