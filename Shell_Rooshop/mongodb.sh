#!/bin/bash

source ./common.sh

chekck_root



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

print_total_time





