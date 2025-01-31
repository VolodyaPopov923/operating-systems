#!/bin/bash

SCRIPT_PATH="./1_datetime.bash"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Скрипт $SCRIPT_PATH не найден!"
    exit 1
fi

chmod +x "$SCRIPT_PATH"

CRON_JOB="*/5 * * * 3 $SCRIPT_PATH"

(crontab -l | grep -v -F "$SCRIPT_PATH"; echo "$CRON_JOB") | crontab -

echo "Задание cron успешно установлено: $CRON_JOB"
