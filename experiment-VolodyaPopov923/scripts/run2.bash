#!/bin/bash

N=9000000
K=30

for ((i=0; i<K; i++))
do
    ./newmem.bash $N &
done
