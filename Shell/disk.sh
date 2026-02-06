#!bin/bash

THRESHOLD=3

df -HT | grep -v Filesystem | while IFS= read -r line; do
    # Split fields
    USAGE=$(echo "$line" | awk '{print $5}' | tr -d '%')
    DISK=$(echo "$line" | awk '{print $7}')
    
    if [ $USAGE -ge $THRESHOLD ]; then
        echo "Warning: Disk usage is high on $DISK ($USAGE%)"
    fi
done