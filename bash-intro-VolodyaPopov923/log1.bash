#!/bin/bash

awk '$5 ~ /^systemd\[/' /var/log/syslog > system.log
