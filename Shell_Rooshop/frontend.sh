
#!/bin/bash
source ./common.sh
app_name=frontend
app_directory=/usr/share/nginx/html
chekck_root

dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE

VALIDATE $? "install nginx"

systemctl enable nginx &>>$LOGS_FILE
systemctl start nginx &>>$LOGS_FILE

VALIDATE $? "start nginx"

rm -rf $app_directory/* 
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

print_total_time








