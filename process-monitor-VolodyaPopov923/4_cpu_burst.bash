#!/bin/bash

output_file="process_info.txt"

> "$output_file"

for pid_dir in /proc/[0-9]*; do
    pid=$(basename "$pid_dir")

    status_file="$pid_dir/status"
    if [[ -r "$status_file" ]]; then
        ppid=$(grep '^PPid:' "$status_file" | awk '{print $2}')
    else
        continue
    fi

    sched_file="$pid_dir/sched"
    if [[ -r "$sched_file" ]]; then
        sum_exec_runtime=$(awk -F ': *' '/sum_exec_runtime/ {print $2}' "$sched_file")
        nr_switches=$(awk -F ': *' '/nr_switches/ {print $2}' "$sched_file")

        if [[ -n "$nr_switches" && "$nr_switches" =~ ^[0-9]+$ && "$nr_switches" -gt 0 ]]; then
            ART=$(awk "BEGIN {printf \"%.2f\", $sum_exec_runtime / $nr_switches}")
        else
            ART=0
        fi
    else
        ART=0
    fi

    echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$ART" >> "$output_file"
done

awk -F' : ' '{ split($2, a, "="); print a[2] " " $0 }' "$output_file" | sort -n | cut -d' ' -f2- > "${output_file}.sorted"
mv "${output_file}.sorted" "$output_file"

echo "Информация о процессах сохранена в файле $output_file и отсортирована по Parent_ProcessID."
