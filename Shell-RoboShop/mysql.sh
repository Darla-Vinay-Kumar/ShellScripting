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
dnf install mysql-server -y &>> $LogFile
Validate $? "installing MySQL Server"
systemctl enable mysqld &>> $LogFile
Validate $? "enabling MySQL Server"
systemctl start mysqld &>> $LogFile
Validate $? "starting MySQL Server"
mysql_secure_installation --set-root-pass RoboShop@1 &>> $LogFile
Validate $? "setting MySQL root password"


End_Time=$(date +%s)
Total_Time=$((End_Time - Start_Time))
echo "Total execution time: $Total_Time seconds" | tee -a $LogFile