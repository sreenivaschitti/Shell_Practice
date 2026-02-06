#!/bin/bash

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}
USERID=$(id -u)
LOGS_DIR="/var/log/backup"
LOGS_FILE="$LOGS_FILE/$0.log"


if [ $USERID -ne 0 ]; then

echo "please run with ROOT user" &>$LOGS_FILE

fi

mkdir -p $LOGS_DIR

USAGE(){

echo " source and destination files required"
exit 1

}

log(){

    echo " $(date '+%Y-%m-%d %H:%M:%S') | $1 " | tee -a $LOGS_FILE
}

if [ $# -lt 2 ]; then

USAGE

fi


if [ ! -d $SOURCE_DIR ]; then

echo "$SOURCE_DIR is not available"
exit 1

fi

if [ ! -d $DEST_DIR_DIR ]; then

echo "$DEST_DIR is available"
exit 1

fi

FILES=$( find $SOURE_DIR -type f -mtime +"$DAYS" )

log "backup started"
log "source $SOURCE_DIR"
log "desti $DEST_DIR"
log "$DAYS"



if [ -z "${FILES}" ]; then
    log "No files to archieve ... $Y Skipping $N"
else
    # app-logs-$timestamp.zip
    log "Files found to archieve: $FILES"
    TIMESTAMP=$(date +%F-%H-%M-%S)
    ZIP_FILE_NAME="$DEST_DIR/app-logs-$TIMESTAMP.tar.gz"
    log "Archieve name: $ZIP_FILE_NAME"
    tar -zcvf $ZIP_FILE_NAME $(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)

    # Check archieve is success or not
    if [ -f $ZIP_FILE_NAME ]; then
        log "Archeival is ... $G SUCCESS $N"

        while IFS= read -r filepath; do
        # Process each line here
        log "Deleting file: $filepath"
        rm -f $filepath
        log "Deleted file: $filepath"
        done <<< $FILES
    else
        log "Archeival is ... $R FAILURE $N"
        exit 1
    fi
fi