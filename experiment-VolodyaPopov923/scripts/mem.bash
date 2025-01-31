#!/bin/bash

: > report.log

iteration=0
numbers=()

while true
do
    numbers+=(1 2 3 4 5 6 7 8 9 10)
    iteration=$(( iteration + 1 ))
    if ! (( iteration % 100000 ))
    then
        echo ${#numbers[@]} >> report.log
    fi
done
