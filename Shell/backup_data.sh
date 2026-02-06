#!/bin/bash

SOURE_DIR=$1
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


if [ ! -d $SOURE_DIR ]; then

echo "$SOURE_DIR is not available"
exit 1

fi

if [ ! -d $DEST_DIR_DIR ]; then

echo "$SOURE_DIR is available"
exit 1

fi

FILES=$( find $SOURE_DIR -type f -mtime +"$DAYS" )

log "backup started"
log "source $SOURE_DIR"
log "desti $DEST_DIR"
log "$DAYS"



if [ -z "$FILES" ]; then

    log "No Files"
    exit 1

    else 

    log "Files found to archive $FILES"

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    ZIP_FILE_NAME="$DEST_DIR/app-logs-$TIMESTAMP.tar.gz"
    log "Archieve name: $ZIP_FILE_NAME"
    tar -zcvf $ZIP_FILE_NAME $( find $SOURE_DIR -type f -mtime +"$DAYS" )

fi

if [ -f $ZIP_FILE_NAME ]; then

    log " archive is sucess"

    else

    log "arcive failure"

fi