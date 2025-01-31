#!/bin/bash

man bash | tr -cs '[:alpha:]' '\n' | grep -E '^.{4,}$' | sort | uniq -c | sort -nr | head -n 3 | awk '{print $2}'
