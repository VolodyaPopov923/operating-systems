#!/bin/bash

FIFO="/tmp/my_fifo"
MODE="add"
RESULT=1
PRODUCER_PID=$(pgrep -f "5_producer.bash")

echo "Начальное состояние: результат=$RESULT, режим=сложение"

while true; do
  if read line < "$FIFO"; then
    case $line in
      "+")
        MODE="add"
        echo "Режим переключен на: сложение"
        ;;
      "*")
        MODE="multiply"
        echo "Режим переключен на: умножение"
        ;;
      "QUIT")
        echo "Плановая остановка обработчика."
	kill "$PRODUCER_PID"
        break
        ;;
      [0-9]*)
        if [[ "$MODE" == "add" ]]; then
          RESULT=$((RESULT + line))
        elif [[ "$MODE" == "multiply" ]]; then
          RESULT=$((RESULT * line))
        fi
        echo "Текущий результат: $RESULT"
        ;;
      *)
        echo "Ошибка: некорректный ввод '$line'. Завершение."
        break
        ;;
    esac
  fi
done
