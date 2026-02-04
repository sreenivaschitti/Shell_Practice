#!/bin/bash

source ./service.sh

chekck_root()



cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "rabbit mq copied"

dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "install rabbitmq-server"

systemctl enable rabbitmq-server &>>$LOGS_FILE
VALIDATE $? "enable rabbitmq-server"

systemctl start rabbitmq-server &>>$LOGS_FILE
VALIDATE $? "start rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "created user and gien permissions"

print_total_time