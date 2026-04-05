#!/bin/bash
USERID=$(id -u)
#Check if the user is root or not
R="\e[31m" #Red Color
G="\e[32m" #Green Color
Y="\e[33m" #Yellow Color
N="\e[0m" #Normal Color
Logs_Folder="/var/log/ShellS-Roboshop"
Script_Dir=$(pwd)
MongoDb_Host="mongodb.darla.vinaykumar.fun"
ScriptName=$( echo $0 | cut -d "." -f1 )
LogFile="$Logs_Folder/$ScriptName-$(date +%F-%H-%M-%S).log"
MYSQL_HOST=mysql.darlavinaykumar.fun

mkdir -p $Logs_Folder
echo "script started at $(date)" | tee -a $LogFile

if [ $USERID -eq 0 ]; then
    echo -e "${G}You are root user, you can install the software${N}"
else
    echo -e "${R}Please run this with Root Privileges${N}"
    exit 1
fi

#Function to validate the installation of software
Validate(){
    
    if [ $1 -eq 0 ]; then
        echo -e "${G}..$2 successfully${N}" | tee -a $LogFile
    else
        echo -e "${R}..Failed to $2${N}" | tee -a $LogFile
        exit 1
    fi
}
dnf install maven -y &>> $LogFile
Validate $? "installing maven"

id roboshop &>> $LogFile
if [ $? -eq 0 ]; then
    echo -e "${Y}roboshop user already exists${N}" | tee -a $LogFile
else
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LogFile
    Validate $? "creating roboshop user"
fi
mkdir -p /app &>> $LogFile
Validate $? "creating /app directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>> $LogFile
Validate $? "downloading shipping code"
cd /app &>> $LogFile
Validate $? "changing to app directory"
rm -rf /app/* &>> $LogFile
unzip /tmp/shipping.zip &>> $LogFile
Validate $? "extracting shipping code"
mvn clean package &>> $LogFile
mv target/shipping-1.0.jar shipping.jar &>> $LogFile
cp $Script_Dir/shipping.service /etc/systemd/system/shipping.service &>> $LogFile
Validate $? "copying shipping.service file"
systemctl daemon-reload &>> $LogFile
Validate $? "reloading systemd"
systemctl enable shipping &>> $LogFile
Validate $? "enabling shipping service"
dnf install mysql -y &>> $LogFile
Validate $? "installing mysql client"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>> $LogFile

if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>> $LogFile
    Validate $? "loading shipping schema to MYSQL"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LogFile
    Validate $? "loading app user schema to MYSQL"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $LogFile
    Validate $? "loading master data to MYSQL" 
else
    echo -e "${Y}Shipping schema already exists in MYSQL. Skipping schema load.${N}" | tee -a $LogFile
  
fi
systemctl restart shipping &>> $LogFile
Validate $? "restarting shipping service"