#!/bin/bash

HANDLER_PID_FILE="/tmp/handler_pid"
echo $$ > "$HANDLER_PID_FILE"

RESULT=1
MODE="add"

handle_usr1() {
  MODE="add"
}

handle_usr2() {
  MODE="multiply"
}

handle_sigterm() {
  echo "Обработчик завершает работу по сигналу SIGTERM."
  rm -f "$HANDLER_PID_FILE"
  exit 0
}

trap 'handle_usr1' USR1
trap 'handle_usr2' USR2
trap 'handle_sigterm' SIGTERM

echo "Обработчик запущен. Начальное значение: $RESULT."

while true; do
  case "$MODE" in
    "add")
      RESULT=$((RESULT + 2))
      ;;
    "multiply")
      RESULT=$((RESULT * 2))
      ;;
  esac
  echo "Текущий результат: $RESULT"
  sleep 1
done
