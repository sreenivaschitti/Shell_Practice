#!bin/bash

DISKUSAGE=$( df -HT | grep -v Filesystem | awk '{print $6}' | cut -d '%' -f1)

echo $DISKUSAGE

DISH_TRESHHOLD=3

while IFS= read -r value; do

    USAGE=$( df -HT | grep -v Filesystem | awk '{print $6}' | cut -d '%' -f1)
    DISK=$( df -HT | grep -v Filesystem | awk '{print $7}' )

    echo "value: $value"
    if [ $value -ge $DISH_TRESHHOLD ]; then
    Message+="High disk $USAGE:$DISK" 
    fi
done < $DISKUSAGE

echo "$Message"