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

dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE

VALIDATE $? "install nginx"

systemctl enable nginx &>>$LOGS_FILE
systemctl start nginx &>>$LOGS_FILE

VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove default content" 

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "download frontend"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "unzip frontend"

cp nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "copied nginx.conf"

systemctl restart nginx 
VALIDATE $? "restarted"








