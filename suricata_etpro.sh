#!/bin/bash

# Set the path for the log file
log_file="/etc/suricata/etpro.log" 

# Execute ET Pro Rule download
echo "Updates ET Pro Rules."
oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules >> "$log_file" 2>&1 &

# Wait for the ET Pro Rules update to complete
wait

# Execute suricata rules update here
echo "File size has changed. Executing Suricata Rules Update."
suricata-update -c /etc/suricata/suricata.yaml --disable-conf=/etc/suricata/disable.conf >> "$log_file" 2>&1
        
# Wait for the suricata update to complete
wait
        
# Execute the suricata restart
echo "Suricata update completed. Executing suricata restart."
systemctl restart suricata >> "$log_file" 2>&1
