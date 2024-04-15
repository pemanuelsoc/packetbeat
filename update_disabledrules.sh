#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# -----------------------------------------------------------------------------
# Copyright (C) DNS Overwatch
#

#!/bin/bash

# Set the path to the file you want to monitor
file_path="/etc/suricata/disable.conf"

# Set the path to store the previous size
prev_size_file="/etc/suricata/prev_disable_size.txt"

# Set the path for a lock file to prevent concurrent executions
lock_file="/etc/suricata/lock_disable.txt"

# Set the path for the log file
log_file="/etc/suricata/update_disabledrules.txt"

# Check if the lock file exists (indicating another instance is running)
if [ -e "$lock_file" ]; then
    echo "Another instance is already running. Exiting."
    exit 1
fi

# Create the lock file
touch "$lock_file"

# Check if the previous size file exists
if [ -e "$prev_size_file" ]; then
    # Read the previous size from the file
    prev_size=$(cat "$prev_size_file")

    # Get the current size of the file
    current_size=$(stat -c %s "$file_path")

    # Compare the sizes
    if [ "$current_size" -ne "$prev_size" ]; then
        # Execute suricata rules update here
        echo "File size has changed. Executing Suricata Rules Update."
        suricata-update -c /etc/suricata/suricata.yaml --disable-conf=/etc/suricata/disable.conf >> "$log_file" 2>&1 &

        # Wait for the suricata update to complete
        wait

        # Execute the suricata restart
        echo "Suricata update completed. Executing suricata restart."
        systemctl restart suricata >> "$log_file" 2>&1
    else
        echo "File size has not changed."
    fi
else
    echo "Previous size file not found. Creating it." >> "$log_file"
fi

# Save the current size for the next run
echo "$current_size" > "$prev_size_file"

# Remove the lock file
rm "$lock_file"
