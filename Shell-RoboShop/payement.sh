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
dnf install python3 gcc python3-devel -y &>> $LogFile
Validate $? "installing python3"

id roboshop &>> $LogFile
if [ $? -eq 0 ]; then
    echo -e "${Y}roboshop user already exists${N}" | tee -a $LogFile
else
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LogFile
    Validate $? "creating roboshop user"
fi
mkdir -p /app &>> $LogFile
Validate $? "creating /app directory"

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip  &>> $LogFile
Validate $? "downloading payment code"
cd /app &>> $LogFile
Validate $? "changing to app directory"
rm -rf /app/* &>> $LogFile
unzip /tmp/payment.zip &>> $LogFile
Validate $? "extracting payment code"
pip3 install -r requirements.txt &>> $LogFile
Validate $? "installing payment dependencies"

cp $Script_Dir/payment.service /etc/systemd/system/payment.service &>> $LogFile
Validate $? "copying payment.service file"

systemctl daemon-reload &>> $LogFile
Validate $? "reloading systemd"
systemctl enable payment &>> $LogFile
Validate $? "enabling payment service"

systemctl restart payment &>> $LogFile
Validate $? "restarting payment service"