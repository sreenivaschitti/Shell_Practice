#!/bin/bash
R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'
LOGS_FOLDER="/var/log/Shell_Roboshop"
LOGS_FILE=$LOGS_FOLDER/$0.log
USERID=$(id -u)
MONGODB_SERVER_IPADDRESS="mongodb.chittis.online"
SCRIPT_DIR=$PWD


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

dnf module enable nodejs:20 -y &>>$LOGS_FILE
VALIDATE $? "nable nodejs:20"

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "install nodejs"

id roboshop 
if [ $? -ne 0 ]; then
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

unzip /tmp/catalogue.zip &>>$LOGS_FILE
VALIDATE $? "catalogue downloaded"


npm install &>>$LOGS_FILE
VALIDATE $? "npm install"

cp $SCRIPT_DIR/catalogue_service /etc/systemd/system/catalogue.service 
VALIDATE $? "copy catalogue service"

systemctl daemon-reload &>>$LOGS_FILE
VALIDATE $? "systemctl daemon-reload"


systemctl enable catalogue &>>$LOGS_FILE
VALIDATE $? "systemctl enable catalogue"

systemctl start catalogue &>>$LOGS_FILE
VALIDATE $? "start catalogue"

cp  $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y &>>$LOGS_FILE
VALIDATE $? "mongodb-mongosh"

Index=(mongosh  mongodb.chittis.online --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ Index -le 0 ]; then

mongosh --host $MONGODB_SERVER_IPADDRESS </app/db/master-data.js &>>$LOGS_FILE

VALIDATE $? "mongodb-mongosh"

else echo "db already loaded"

fi





