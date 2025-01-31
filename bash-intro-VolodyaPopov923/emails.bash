#!/bin/bash

grep -EhoR "[a-zA-Z.+-]+@[a-zA-Z-]+\.[a-zA-Z.-]+" /etc 2>/dev/null | sort -u | paste -sd ',' - > etc_emails.lst
