#!/bin/bash

LOGS_FOLDER="/var/log/Shell_Practice"
LOGS_FILE=$LOGFOLDER/$0.log
USERID=$(id -u)


if [ $USERID -eq 0 ]; then

    echo " run with root user" &>>LOGS_FILE
    exit 1

fi

mkdir -p $LOGFOLDER

VALIDATE(){

    if [ $1 -ne 0 ]; then
        
        echo "$1 ....Failure" &>>LOGS_FILE

    else

        echo "$1 ....Success" &>>LOGS_FILE

    fi        
}

for package in $@

 do 
    dnf list installed $package
    if [ $? eq 0 ]; then

        echo " $package already installed "

    else  

        dnf install $package -y &>>$LOGS_FILE
    
        VALIDATE $? "$package  installation"
 
 done   