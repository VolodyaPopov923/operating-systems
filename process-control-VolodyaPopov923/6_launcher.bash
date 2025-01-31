#!/bin/bash


bash ./6_handler.bash &
HANDLER_PID=$!

sleep 1
bash ./6_producer.bash
