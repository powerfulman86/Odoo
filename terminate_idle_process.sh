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

#!/bin/bash

# Define the idle time threshold in seconds
IDLE_TIME_THRESHOLD=600

# Get the list of all running processes
PROCESS_LIST=$(ps -eo pid,stat,start_time,args)

# Loop through each process
while read -r LINE; do
  # Extract the process ID, start time, and status from the process list
  PID=$(echo "$LINE" | awk '{print $1}')
  START_TIME=$(echo "$LINE" | awk '{print $3}')
  STATUS=$(echo "$LINE" | awk '{print $2}')

  # Calculate the idle time for the process in seconds
  ELAPSED_TIME=$(( $(date +%s) - $(date -d "$START_TIME" +%s) ))

  # Check if the process is idle for more than the threshold
  if [ "$STATUS" == "S" ] && [ "$ELAPSED_TIME" -gt "$IDLE_TIME_THRESHOLD" ]; then
    # Terminate the idle process
    echo "Terminating idle process: $LINE"
    kill -9 "$PID"
  fi
done <<< "$PROCESS_LIST"
