#!/bin/bash

while true; do
    read -r input
    
    if [ "$input" == "q" ]; then
        break
    fi
    length=${#input}
    echo $length
    
    if [[ "$input" =~ ^[a-zA-Z]+$ ]]; then
        echo "true"
    else
        echo "false"
    fi
done
