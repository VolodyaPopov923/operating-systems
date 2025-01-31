#!/bin/bash

: > report2.log

iterations=0
number_array=()

target_size=$1

while (( ${#number_array[@]} < target_size ))
do
    number_array+=(1 2 3 4 5 6 7 8 9 10)
    iterations=$(( iterations + 1 ))
done
