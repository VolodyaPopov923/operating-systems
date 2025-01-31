#!/bin/bash

FIFO="/tmp/my_fifo"
if [[ ! -p $FIFO ]]; then
	mkfifo $FIFO
fi
bash 5_handler.bash &
bash 5_producer.bash

rm -f /tmp/my_fifo
