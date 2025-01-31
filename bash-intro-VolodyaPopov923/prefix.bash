#!/bin/bash

a=$1
b=$2
sum=0

for ((i=a; i<=b; i++)); do
 sum=$((sum+i))
 echo $sum
done
