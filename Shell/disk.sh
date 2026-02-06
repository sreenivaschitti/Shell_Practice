#!bin/bash

DISKUSAGE=$( df -HT | grep -v Filesystem | awk '{print $6}' | cut -d '%' -f1)

echo $DISKUSAGE