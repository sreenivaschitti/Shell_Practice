#!/bin/bash

source ./common.sh

chekck_root()


dnf module disable redis -y &>>$LOGS_FILE
dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "enable redis:7" 

dnf install redis -y &>>$LOGS_FILE
VALIDATE $? "install redis" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$LOGS_FILE
VALIDATE $? "modified 0.0.0.0" 
sudo sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf &>>$LOGS_FILE
VALIDATE $? "modified protected-mode yes" 

systemctl enable redis 
VALIDATE $? "enable redis" 
systemctl start redis 
VALIDATE $? "start redis" 

print_total_time()






