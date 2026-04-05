#!/bin/bash
USERID=$(id -u)
#Check if the user is root or not
R="\e[31m" #Red Color
G="\e[32m" #Green Color
Y="\e[33m" #Yellow Color
N="\e[0m" #Normal Color
Logs_Folder="/var/log/ShellS-Roboshop"
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

#Function to validate the installation of software
Validate(){
    
    if [ $1 -eq 0 ]; then
        echo -e "${G}..$2 successfully${N}" | tee -a $LogFile
    else
        echo -e "${R}..Failed to $2${N}" | tee -a $LogFile
        exit 1
    fi
}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LogFile
Validate $? "adding mongo.repo file"

dnf install mongodb-org -y &>> $LogFile
Validate $? "installing MONGODB"

systemctl enable mongod
Validate $? "enabling MONGODB" 

systemctl start mongod 
Validate $? "starting MONGODB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
Validate $? "allowing remote connection to MONGODB"

systemctl restart mongod
Validate $? "restarting MONGODB"