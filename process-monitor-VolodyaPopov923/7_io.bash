#!/bin/bash

START_FILE=$(mktemp)
END_FILE=$(mktemp)

collect_data() {
    for pid_dir in /proc/[0-9]*; do
        pid=$(basename "$pid_dir")
        
        if [ -r "/proc/$pid/io" ] && [ -r "/proc/$pid/comm" ]; then
            cmdname=$(< /proc/"$pid"/comm)
            
            read_bytes=$(grep '^read_bytes:' /proc/"$pid"/io | awk '{print $2}')
            
            if [[ "$read_bytes" =~ ^[0-9]+$ ]]; then
                echo "$pid:$cmdname:$read_bytes"
            fi
        fi
    done
}

collect_data > "$START_FILE"

sleep 60

collect_data > "$END_FILE"

awk -F: '
    NR==FNR { 
        start[$1]=$3; 
        cmd[$1]=$2; 
        next 
    }
    ($1 in start) { 
        if ($3 > start[$1]) { 
            delta[$1]=$3 - start[$1]; 
            cmd_final[$1]=cmd[$1]
        } 
    }
    END {
        for (pid in delta) {
            print pid ":" cmd_final[pid] ":" delta[pid]
        }
    }
' "$START_FILE" "$END_FILE" | sort -t: -k3 -nr | head -n3

rm "$START_FILE" "$END_FILE"
