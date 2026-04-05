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
dnf module disable redis -y &>> $LogFile
Validate $? "disabling redis module"
dnf module enable redis:7 -y &>> $LogFile
Validate $? "enabling redis module"
dnf install redis -y &>> $LogFile
Validate $? "installing redis"
sed -i 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis.conf &>> $LogFile
Validate $? "updating redis configuration"

systemctl enable redis &>> $LogFile
Validate $? "enabling redis"
systemctl start redis &>> $LogFile
Validate $? "starting redis"
End_Time=$(date +%s)
Total_Time=$((End_Time - Start_Time))
echo "Total execution time: $Total_Time seconds" | tee -a $LogFile