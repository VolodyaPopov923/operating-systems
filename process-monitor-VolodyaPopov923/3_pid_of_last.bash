#!/bin/bash
ps -eo pid,lstart --sort=start_time | tail -n 1 | awk '{print $1, $2, $3, $4, $5, $6}'
