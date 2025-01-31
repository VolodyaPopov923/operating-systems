#!/bin/bash

get_max_mem_process_script() {
    local max_mem=0
    local max_pid=0

    for pid in $(ls /proc | grep '^[0-9]\+$'); do
        if [ -r /proc/$pid/status ]; then
            mem=$(grep VmSize /proc/$pid/status | awk '{print $2}')

            if [[ $mem =~ ^[0-9]+$ ]]; then
                if [ "$mem" -gt "$max_mem" ]; then
                    max_mem=$mem
                    max_pid=$pid
                fi
            fi
        fi
    done

    if [ $max_pid -ne 0 ]; then
        proc_name=$(ps -p $max_pid -o comm=)
        mem_mb=$(echo "scale=2; $max_mem/1024" | bc)
        echo "$max_pid;$proc_name;$mem_mb"
    else
        echo "0;Не определено;0"
    fi
}

get_max_mem_process_top() {
    # Поскольку top по умолчанию не отображает VmSize, этот метод остается с использованием VmRSS
    top_output=$(top -b -n 1 | awk 'NR>7 {print $6, $1, $12}' | sort -nr | head -n 1)
    mem_kb=$(echo $top_output | awk '{print $1}')
    pid=$(echo $top_output | awk '{print $2}')
    proc_name=$(echo $top_output | awk '{print $3}')
    mem_mb=$(echo "scale=2; $mem_kb/1024" | bc)
    echo "$pid;$proc_name;$mem_mb"
}

script_result=$(get_max_mem_process_script)
script_pid=$(echo $script_result | cut -d';' -f1)
script_name=$(echo $script_result | cut -d';' -f2)
script_mem=$(echo $script_result | cut -d';' -f3)

top_result=$(get_max_mem_process_top)
top_pid=$(echo $top_result | cut -d';' -f1)
top_name=$(echo $top_result | cut -d';' -f2)
top_mem=$(echo $top_result | cut -d';' -f3)

echo "=== Результат скрипта (VmSize) ==="
if [ "$script_pid" -ne 0 ]; then
    echo "PID: $script_pid"
    echo "Имя процесса: $script_name"
    echo "Выделенная память: $script_mem MB"
else
    echo "Не удалось определить процесс с наибольшим использованием памяти."
fi

echo ""
echo "=== Результат команды top ==="
if [ "$top_pid" -ne 0 ]; then
    echo "PID: $top_pid"
    echo "Имя процесса: $top_name"
    echo "Используемая память: $top_mem MB"
else
    echo "Не удалось определить процесс с наибольшим использованием памяти через top."
fi

echo ""
echo "=== Сравнение результатов ==="
if [ "$script_pid" -eq "$top_pid" ]; then
    echo "Оба метода совпадают. PID: $script_pid, Имя процесса: $script_name, Память: $script_mem MB"
else
    echo "Различие в результатах:"
    echo "Скрипт (VmSize): PID $script_pid, Имя $script_name, Память $script_mem MB"
    echo "Top: PID $top_pid, Имя $top_name, Память $top_mem MB"
fi
