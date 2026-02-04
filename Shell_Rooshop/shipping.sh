#!/bin/bash
source ./common.sh
app_name=shipping
MYSQL_SERVER_IPADDRESS=mysql.chittis.online

app_setup
java_setup


SYSTEM_SETUP


dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "install mysql"

mysql -h $MYSQL_SERVER_IPADDRESS -uroot -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ]; then

    mysql -h $MYSQL_SERVER_IPADDRESS -uroot -pRoboShop@1 < /app/db/schema.sql
    mysql -h $MYSQL_SERVER_IPADDRESS -uroot -pRoboShop@1 < /app/db/app-user.sql 
    mysql -h $MYSQL_SERVER_IPADDRESS -uroot -pRoboShop@1 < /app/db/master-data.sql
    VALIDATE $? "loaded data"

    else
        echo "Data already exist"
        echo "Data already exist"

fi

app_restart
print_total_time