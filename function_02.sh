#!/bin/bash

LOGS_FOLDER="/var/log/Shell_Practice"
LOGS_FILE=$LOGS_FOLDER/$0.log
USERID=$(id -u)


if [ $USERID -ne 0 ]; then

    echo " run with root user" | tee -a $LOGS_FILE
    exit 1

fi

mkdir -p $LOGS_FOLDER

VALIDATE(){

    if [ $1 -ne 0 ]; then
        
        echo "$1 ....Failure" | tee -a $LOGS_FILE

    else

        echo "$1 ....Success" |  tee -a $LOGS_FILE

    fi        
}

 

:<<'COMMENT'
 for package in $@ # sudo sh 14-loops.sh nginx mysql nodejs
do
    dnf list installed $package &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        echo "$package not installed, installing now"
        dnf install $package -y &>>$LOGS_FILE
        VALIDATE $? "$package installation"
    else
        echo "$package already installed, skipping"
    fi
done
COMMENT
