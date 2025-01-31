#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <ширина> <высота>"
    exit 1
fi

if ! [[ "$1" =~ ^[0-9]+$ ]] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
    echo "Ширина и высота должны быть положительными целыми числами"
    exit 1
fi

width=$1
height=$2

x=$((width / 2))
y=$((height / 2))

echo "x=$x;y=$y"

old_stty=$(stty -g)

stty -icanon -echo

while true; do
    read -n1 key

    case "$key" in
        "q")
            break
            ;;
        "w"|"W")
            y=$((y + 1))
            ;;
        "s"|"S")
            y=$((y - 1))
            ;;
        "a"|"A")
            x=$((x - 1))
            ;;
        "d"|"D")
            x=$((x + 1))
            ;;
        *)
            continue
            ;;
    esac

    echo "x=$x;y=$y"
    if [ "$x" -lt 0 ]  [ "$x" -ge "$width" ]  [ "$y" -lt 0 ] || [ "$y" -ge "$height" ]; then
        break
    fi
done
