#!/bin/bash

# Thresholds for CPU and RAM usage
CPU_THRESHOLD=80
RAM_THRESHOLD=80

# Function to get the highest CPU-consuming process
get_highest_cpu_process() {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -2 | tail -1
}

# Function to get the highest RAM-consuming process
get_highest_ram_process() {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -2 | tail -1
}

while true; do
    # Get CPU and RAM usage percentages
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

    # Check if either CPU or RAM usage exceeds the threshold
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )) || (( $(echo "$RAM_USAGE > $RAM_THRESHOLD" | bc -l) )); then
        
        # Determine whether CPU or RAM is the cause
        if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
            resource_type="CPU"
            process_info=$(get_highest_cpu_process)
        else
            resource_type="RAM"
            process_info=$(get_highest_ram_process)
        fi
        
        # Extracting process details
        pid=$(echo $process_info | awk '{print $1}')
        service_name=$(echo $process_info | awk '{print $3}')

        # Create the alert message
        alert_message="High $resource_type usage detected!\n\nThe process consuming the most resources is:\n\n$process_info\n\nTo stop this service, you can run the following command:\n\nsudo systemctl stop $service_name\n\nOr if it's not a service, you can kill the process with:\n\nsudo kill -9 $pid"

        # Display the GUI pop-up alert using zenity
        zenity --warning --title="Resource Usage Alert" --text="$alert_message"
    fi

    # Wait for a minute before the next check
    sleep 60
done

