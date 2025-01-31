#!/bin/bash

backup_dir_base="$HOME"
source_dir="$HOME/source"
backup_report="$HOME/backup-report"
current_date=$(date +%Y-%m-%d)
backup_dir="$backup_dir_base/Backup-$current_date"

if [ ! -d "$source_dir" ]; then
    echo "Ошибка: исходный каталог '$source_dir' не существует." >&2
    exit 1
fi

existing_backup=$(find "$backup_dir_base" -maxdepth 1 -type d -name "Backup-*" \
    -exec bash -c 'basename {} | cut -d"-" -f2-' \; | \
    grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}$" | \
    awk -v date="$current_date" 'BEGIN { split(date, d, "-"); ref_date = mktime(d[1]" "d[2]" "d[3]" 0 0 0) - 7 * 86400; }
        { split($1, b, "-"); b_date = mktime(b[1]" "b[2]" "b[3]" 0 0 0); if (b_date >= ref_date) print $1; }'
)

if [ -z "$existing_backup" ]; then
    mkdir "$backup_dir"
    cp -r "$source_dir"/* "$backup_dir"/

    echo "[$(date +%Y-%m-%d %H:%M:%S)] Создан новый каталог резервного копирования: $backup_dir" >> "$backup_report"
    echo "Список скопированных файлов:" >> "$backup_report"
    ls "$backup_dir" >> "$backup_report"
else
    backup_dir="$backup_dir_base/Backup-$existing_backup"
    echo "[$(date +%Y-%m-%d %H:%M:%S)] Изменения в существующем каталоге резервного копирования: $backup_dir" >> "$backup_report"

    for file in "$source_dir"/*; do
        file_name=$(basename "$file")
        target_file="$backup_dir/$file_name"

        if [ ! -e "$target_file" ]; then
            cp "$file" "$backup_dir/"
            echo "$file_name" >> "$backup_report"
        else
            source_size=$(stat -c%s "$file")
            target_size=$(stat -c%s "$target_file")

            if [ "$source_size" -ne "$target_size" ]; then
                versioned_file="$target_file.$current_date"
                mv "$target_file" "$versioned_file"
                cp "$file" "$backup_dir/"

                echo "$file_name $versioned_file" >> "$backup_report"
            fi
        fi
    done
fi

exit 0
