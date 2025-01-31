#!/bin/bash

HANDLER_PID_FILE="/tmp/handler_pid"
echo $$ > "$HANDLER_PID_FILE"

ATTEMPTS=10
SECRET_NUMBER=$((RANDOM % 100 + 1))

handle_guess() {
  local GUESS=$1
  if [[ $GUESS -eq $SECRET_NUMBER ]]; then
    echo "Вы угадали число $SECRET_NUMBER! Победа!"
    rm -f "$HANDLER_PID_FILE"
    exit 0
  elif [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo "Загаданное число больше."
  else
    echo "Загаданное число меньше."
  fi
  ATTEMPTS=$((ATTEMPTS - 1))
  if [[ $ATTEMPTS -le 0 ]]; then
    echo "Вы проиграли! Загаданное число было: $SECRET_NUMBER."
    rm -f "$HANDLER_PID_FILE"
    exit 0
  fi
}

handle_show() {
  echo "Осталось попыток: $ATTEMPTS"
}

handle_quit() {
  echo "Игра завершена. Загаданное число было: $SECRET_NUMBER."
  rm -f "$HANDLER_PID_FILE"
  exit 0
}

trap 'handle_guess $GUESS' USR1
trap 'handle_show' USR2
trap 'handle_quit' SIGTERM

echo "Обработчик запущен. Угадайте число от 1 до 100."

while true; do
  sleep 1
done
