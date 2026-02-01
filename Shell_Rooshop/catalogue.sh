#!/bin/bash
R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'
LOGS_FOLDER="/var/log/Shell_Roboshop"
LOGS_FILE=$LOGS_FOLDER/$0.log
USERID=$(id -u)
MONGODB_SERVER_IPADDRESS="mongodb.chittis.online"


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

dnf module disable nodejs -y &>>$LOGS_FILE
VALIDATE $? "disable nodejs"

dnf module enable nodejs:20 -y 
VALIDATE $? "nable nodejs:20"

dnf install nodejs -y 
VALIDATE $? "install nodejs"

id roboshop 
if [ $? -ne 0]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        VALIDATE $? "user added"

    else echo "user alredy exist"

fi


mkdir -p /app
VALIDATE $? "creating directory"


curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "dowloadig catalogu code"

cd /app 
VALIDATE $? "movig to app folder"

rm -rf /app/*
VALIDATE $? "removing files in app"

unzip /tmp/catalogue.zip
VALIDATE $? "catalogue downloaded"


npm install 
VALIDATE $? "npm install"

cp catalogue_service /etc/systemd/system/catalogue.service
VALIDATE $? "copy catalogue service"

systemctl daemon-reload
VALIDATE $? "systemctl daemon-reload"


systemctl enable catalogue 
VALIDATE $? "systemctl enable catalogue"

systemctl start catalogue
VALIDATE $? "start catalogue"

cp  mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y
VALIDATE $? "mongodb-mongosh"

mongosh --host $MONGODB_SERVER_IPADDRESS </app/db/master-data.js

VALIDATE $? "mongodb-mongosh"





