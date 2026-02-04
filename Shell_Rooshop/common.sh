#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'
SCRIPT_DIR=$PWD
LOGS_FOLDER="/var/log/Shell_Roboshop"
LOGS_FILE=$LOGS_FOLDER/$0.log
USERID=$(id -u)
START_TIME=$(date +"%S")

mkdir -p $LOGS_FOLDER

chekck_root(){

    if [ $USERID -ne 0 ]; then

    echo   " run with root user" | tee -a $LOGS_FILE
    exit 1

    fi
}

VALIDATE(){

    if [ $1 -ne 0 ]; then
        
        echo -e "$(date +"%Y-%m-%d %H:%M:%S") | $2 ....$R Failure" | tee -a $LOGS_FILE

    else

        echo -e "$(date +"%Y-%m-%d %H:%M:%S") | $2 ...$G Success" |  tee -a $LOGS_FILE

    fi        
}

print_total_time(){
    
    END_TIME=$(date +"%S")
    TOTAL_TIME=$END_TIME-$START_TIME
    echo -e  "$(date +"%Y-%m-%d %H:%M:%S") | Script executed in $TOTAL_TIME seconds" |  tee -a $LOGS_FILE

}

nodejs_setup(){

    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "disable nodejs"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "nable nodejs:20"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "install nodejs"

    npm install &>>$LOGS_FILE
    VALIDATE $? "npm install"

}

app_setup(){

    id roboshop 
    if [ $? -ne 0 ]; then
            useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
            VALIDATE $? "user added"

        else echo "user alredy exist"

    fi


    mkdir -p /app
    VALIDATE $? "creating directory"


    curl -o  $ /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip 
    VALIDATE $? "dowloadig $app_name code"

    cd /app 
    VALIDATE $? "movig to app folder"

    rm -rf /app/*
    VALIDATE $? "removing files in app"

    unzip /tmp/$app_name.zip &>>$LOGS_FILE
    VALIDATE $? "$app_name downloaded"


}

SYSTEM_SETUP(){
    cp $SCRIPT_DIR/$app_name_service /etc/systemd/system/$app_name.service 
    VALIDATE $? "copy $app_name service"

    systemctl daemon-reload &>>$LOGS_FILE
    VALIDATE $? "systemctl daemon-reload"


    systemctl enable $app_name &>>$LOGS_FILE
    VALIDATE $? "systemctl enable $app_name"

    systemctl start $app_name &>>$LOGS_FILE
    VALIDATE $? "start $app_name"
}

app_restart(){

    systemctl restart $app_name &>>$LOGS_FILE
    VALIDATE $? "restarted $app_name"

}

java_setup(){

    dnf install maven -y &>>$LOGS_FILE
    VALIDATE $? "install maven"

    mvn clean package 
    mv target/$app_name-1.0.jar $app_name.jar 
    VALIDATE $? "mvn install"




}

python_setup(){
    dnf install python3 gcc python3-devel -y &>>$LOGS_FILE
    VALIDATE $? "Installing Python"

    cd /app 
    pip3 install -r requirements.txt &>>$LOGS_FILE
    VALIDATE $? "Installing dependencies"
}