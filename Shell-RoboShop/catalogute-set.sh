#!/bin/bash
set -euo pipefail
trap 'echo"There is an error at line $LINENO while executing: $BASH_COMMAND"' ERR
USERID=$(id -u)
#Check if the user is root or not
R="\e[31m" #Red Color
G="\e[32m" #Green Color
Y="\e[33m" #Yellow Color
N="\e[0m" #Normal Color
Logs_Folder="/var/log/ShellS-Roboshop"
Script_Dir=$(pwd)
MongoDb_Host="mongodb.darlavinaykumar.fun"
ScriptName=$( echo $0 | cut -d "." -f1 )
LogFile="$Logs_Folder/$ScriptName-$(date +%F-%H-%M-%S).log"

mkdir -p $Logs_Folder
echo "script started at $(date)" | tee -a $LogFile

if [ $USERID -eq 0 ]; then
    echo -e "${G}You are root user, you can install the software${N}"
else
    echo -e "${R}Please run this with Root Privileges${N}"
    exit 1
fi



dnf module disable nodejs -y &>> $LogFile

dnf module enable nodejs:20 -y &>> $LogFile

dnf install nodejs -y &>> $LogFile
echo "installing nodejs" | tee -a $LogFile

id roboshop &>> $LogFile
if [ $? -eq 0 ]; then
    echo -e "${Y}roboshop user already exists${N}" | tee -a $LogFile
else
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LogFile
    
fi
mkdir -p /app &>> $LogFile


curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>> $LogFile
echo "downloading catalogue code" | tee -a $LogFile

cd /app     &>> $LogFile
echo "changing to app directory" | tee -a $LogFile
rm -rf /app/* &>> $LogFile

unzip /tmp/catalogue.zip &>> $LogFile
echo "extracting catalogue code" | tee -a $LogFile

npm install &>> $LogFile


cp $Script_Dir/catalogue.service /etc/systemd/system/catalogue.service &>> $LogFile


systemctl daemon-reload &>> $LogFile


systemctl enable catalogue &>> $LogFile


systemctl start catalogue &>> $LogFile
echo "starting catalogue service" | tee -a $LogFile

cp $Script_Dir/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LogFile


dnf install mongodb-mongosh -y &>> $LogFile
echo "installing MONGODB" | tee -a $LogFile


# Check if the collection exists before loading schema
COLLECTION_EXISTS=$(mongosh --host $MongoDb_Host --quiet --eval "db.getMongo().getDBName().indexOf('catalogue') >= 0")
if [ "$COLLECTION_EXISTS" = "true" ]; then
    echo -e "${Y}MongoDB collection 'products' already exists. Skipping schema load.${N}" | tee -a $LogFile
    echo "MongoDB collection 'products' already exists. Skipping schema load." | tee -a $LogFile
else
    mongosh --host $MongoDb_Host </app/db/master-data.js &>> $LogFile
    echo "loading catalogue schema to MONGODB" | tee -a $LogFile
   
fi

systemctl restart catalogue &>> $LogFile
echo "restarting catalogue service" | tee -a $LogFile
