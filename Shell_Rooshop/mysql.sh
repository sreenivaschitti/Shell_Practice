source ./common.sh

chekck_root

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "install mysql-server"

systemctl enable mysqld
VALIDATE $? "enable mysql-server"

systemctl start mysqld  
VALIDATE $? "start mysql-server"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "pasword"


