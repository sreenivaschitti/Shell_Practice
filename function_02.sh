#!/bin/bash

LOGS_FOLDER="/var/log/Shell_Practice"
LOGS_FILE=$LOGFOLDER/$0.log
USERID=$(id -u)


if [ $USERID -ne 0 ]; then

    echo " run with root user" | tee -a $LOGS_FILE
    exit 1

fi

mkdir -p $LOGS_FOLDER

VALIDATE(){

    if [ $1 -ne 0 ]; then
        
        echo "$1 ....Failure" &>>LOGS_FILE

    else

        echo "$1 ....Success" &>>LOGS_FILE

    fi        
}

for package in $@

 do 
    dnf list installed $package tee -a $LOGS_FILE
    if [ $? -ne 0 ]; then

        dnf install $package -y &>>$LOGS_FILE
    
        VALIDATE $? "$package  installation"
        

    else  
        echo " $package already installed "
        
    fi

 done   