#!/bin/bash
ps -eo pid,cmd | grep -E '^\s*[0-9]+\s+/sbin/' | awk '{print $1}' > pids_from_sbin.txt
