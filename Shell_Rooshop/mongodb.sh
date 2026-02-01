#!/bin/bash
R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'
LOGS_FOLDER="/var/log/Shell_Roboshop"
LOGS_FILE=$LOGS_FOLDER/$0.log
USERID=$(id -u)


if [ $USERID -ne 0 ]; then

    echo   " run with root user" | tee -a $LOGS_FILE
    exit 1

fi

mkdir -p $LOGS_FOLDER

VALIDATE(){

    if [ $1 -ne 0 ]; then
        
        echo -e "$2 ....$R Failure" | tee -a $LOGS_FILE

    else

        echo -e "$2 ...$G Success" |  tee -a $LOGS_FILE

    fi        
}

cp mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installation mongodb"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "enable mongod"

systemctl start mongod &>>$LOGS_FILE
VALIDATE $? "start mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGS_FILE
VALIDATE $? "0.0.0.0 updated"

systemctl restart mongod &>>$LOGS_FILE
VALIDATE $? "restart mongod"




