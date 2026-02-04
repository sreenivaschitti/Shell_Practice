#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'

LOGS_DIR=/home/ec2-user/app-logs/
LOGS_FILE=$LOGS_DIR/$0.log

if [ ! -d $LOGS_DIR ]; then

echo -e "$LOGS_DIR does not exit"

exit 1

fi



FILESTODELETE=$( find $LOGS_DIR -name '*.log' -mtime +14 )

echo "$FILESTODELETE"


