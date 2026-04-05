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
Start_Time=$(date +%s)
mkdir -p $Logs_Folder
script_dir=$(pwd)
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

cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $LogFile
Validate $? "adding rabbitmq.repo file"

dnf install rabbitmq-server -y &>> $LogFile
Validate $? "installing RabbitMQ"
systemctl enable rabbitmq-server &>> $LogFile
Validate $? "enabling RabbitMQ"
systemctl start rabbitmq-server &>> $LogFile
Validate $? "starting RabbitMQ"
rabbitmqctl add_user roboshop roboshop123 &>> $LogFile
Validate $? "creating RabbitMQ user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LogFile
Validate $? "setting RabbitMQ user permissions"


End_Time=$(date +%s)
Total_Time=$((End_Time - Start_Time))
echo "Total execution time: $Total_Time seconds" | tee -a $LogFile