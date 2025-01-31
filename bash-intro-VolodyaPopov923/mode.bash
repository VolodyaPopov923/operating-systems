#!/bin/bash

awk -F',' '{
    split($1, datetime, " ");
    date = datetime[1];
    key = date","$2","$4;
    print key "," $0
}' input.csv | sort -u -t, -k1,1 | cut -d, -f2- > output.csv
