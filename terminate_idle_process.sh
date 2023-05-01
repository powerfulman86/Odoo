#!/bin/bash

# Get the current time stamp
now=$(date +%s)

# Loop through all the running processes
for pid in $(ps -eo pid,comm,state,start_time --no-header | awk '$3 ~ /^[SZ]/ {print $1 ":" $4}')
do
    # Extract the process ID and start time
    id=$(echo $pid | cut -d ":" -f 1)
    start=$(echo $pid | cut -d ":" -f 2)

    # Calculate the time difference in seconds
    diff=$((now - $(date -d "$start" +%s)))

    # Check if the process has been idle for more than 10 minutes
    if [ $diff -gt 600 ]
    then
        echo "Terminating process $id"
        kill -9 $id
    fi
done
