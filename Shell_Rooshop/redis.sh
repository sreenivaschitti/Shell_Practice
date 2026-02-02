R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'
LOGS_FOLDER="/var/log/Shell_Roboshop"
LOGS_FILE=$LOGS_FOLDER/$0.log
USERID=$(id -u)


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





