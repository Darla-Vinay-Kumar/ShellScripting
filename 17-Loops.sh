#!/bin/bash
USERID=$(id -u)
#Check if the user is root or not
R="\e[31m" #Red Color
G="\e[32m" #Green Color
Y="\e[33m" #Yellow Color
N="\e[0m" #Normal Color
Logs_Folder="/var/log/IShellScripting"
ScriptName=$( echo $0 | cut -d "." -f1 )
LogFile="$Logs_Folder/$ScriptName-$(date +%F-%H-%M-%S).log"

mkdir -p $Logs_Folder
echo "script started at $(date)" > $LogFile

if [ $USERID -eq 0 ]; then
    echo -e "${G}You are root user, you can install the software${N}"
else
    echo -e "${R}Please run this with Root Privileges${N}"
    exit 1
fi

#Function to validate the installation of software
Validate(){
    dnf install mysql -y
    if [ $1 -eq 0 ]; then
        echo -e "${G}$2 installed successfully${N}"
    else
        echo -e "${R}Failed to install $2${N}"
        exit 1
    fi
}

for package in $@
do 
    dnf list installed $package &>> $LogFile
    if [ $? -eq 0 ]; then
        echo -e "${Y}$package is already installed${N}"
    else
        dnf install $package -y &>> $LogFile
        Validate $? "$package"
    fi
done