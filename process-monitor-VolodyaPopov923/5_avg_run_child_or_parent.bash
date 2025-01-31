#!/bin/bash

input_file="process_info.txt"

output_file="process_info_with_averages.txt"

if [[ ! -f "$input_file" ]]; then
    echo "Исходный файл '$input_file' не найден. Убедитесь, что предыдущий скрипт выполнился успешно."
    exit 1
fi

awk -F ' : ' '
BEGIN {
    current_ppid = ""
    sum_art = 0
    count = 0
}

{
    split($2, a, "=")
    ppid = a[2]

    split($3, b, "=")
    art = b[2]

    if (current_ppid == "") {
        current_ppid = ppid
    }

    if (ppid != current_ppid) {
        if (count > 0) {
            avg = sum_art / count
            printf "Average_Running_Children_of_ParentID=%s is %.2f\n", current_ppid, avg >> "'"$output_file"'"
        }
        current_ppid = ppid
        sum_art = 0
        count = 0
    }

    print $0 >> "'"$output_file"'"

    sum_art += art
    count += 1
}

END {
    if (count > 0) {
        avg = sum_art / count
        printf "Average_Running_Children_of_ParentID=%s is %.2f\n", current_ppid, avg >> "'"$output_file"'"
    }
}
' "$input_file"

echo "Файл '$output_file' успешно создан с добавленными строками средних значений."
