#!/bin/bash
source ./common.sh
app_name=catalogue
MONGODB_SERVER_IPADDRESS=mongodb.chittis.online
chekck_root

app_setup
nodejs_setup
SYSTEM_SETUP

#Loading data into mongod
cp  $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y &>>$LOGS_FILE
VALIDATE $? "mongodb-mongosh"

Index=$(mongosh  $MONGODB_SERVER_IPADDRESS --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
echo "db index $Index"
if [ $Index -le 0 ]; then

mongosh --host $MONGODB_SERVER_IPADDRESS </app/db/master-data.js &>>$LOGS_FILE

VALIDATE $? "mongodb-mongosh"

else 

echo -e "$(date +"%Y-%m-%d %H:%M:%S") | Script executed in $TOTAL_TIME seconds $Y db already loaded"

fi

app_restart





