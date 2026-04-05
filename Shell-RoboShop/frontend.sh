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

dnf module disable nginx -y &>> $LogFile
Validate $? "disabling nginx module"
dnf module enable nginx:1.24 -y &>> $LogFile
Validate $? "enabling nginx module"
dnf install nginx -y &>> $LogFile
Validate $? "installing nginx"

systemctl enable nginx &>> $LogFile
Validate $? "enabling nginx"
systemctl start nginx &>> $LogFile
Validate $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LogFile
Validate $? "cleaning default nginx html directory"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LogFile
Validate $? "downloading frontend code"

cd /usr/share/nginx/html &>> $LogFile &>> $LogFile
Validate $? "changing to nginx html directory"

unzip /tmp/frontend.zip &>> $LogFile &>> $LogFile
Validate $? "extracting frontend code"
rm -rf /etc/nginx/nginx.conf &>> $LogFile
Validate $? "removing default nginx.conf file"

cp $Script_Dir/nginx.conf /etc/nginx/nginx.conf &>> $LogFile
Validate $? "copying nginx.conf file"

systemctl restart nginx &>> $LogFile
Validate $? "restarting nginx"

