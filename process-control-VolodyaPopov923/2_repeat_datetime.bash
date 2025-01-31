#!/bin/bash

echo "/1_datetime.bash" | at now + 2 minutes

tail -f ~/report &
