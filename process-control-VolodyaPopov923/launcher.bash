#!/bin/bash

bash ./handler.bash &
HANDLER_PID=$!

sleep 1
bash ./producer.bash
