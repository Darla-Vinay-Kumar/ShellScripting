#!/bin/bash
USERID=$(id -u)
#Check if the user is root or not
R="\e[31m" #Red Color
G="\e[32m" #Green Color
Y="\e[33m" #Yellow Color
N="\e[0m" #Normal Color
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
#Install MySQL, NGINX and MONGOSH
dnf list installed mysql
if [ $? -eq 0 ]; then
    echo -e "${Y}MySQL is already installed${N}"
else    
    dnf install mysql -y
    Validate $? "MYSQL"
fi
dnf list installed nginx
if [ $? -eq 0 ]; then
    echo -e "${Y}NGINX is already installed${N}"
else
    dnf install nginx -y
    Validate $? "NGINX"
fi
dnf list installed python3
if [ $? -eq 0 ]; then
    echo -e "${Y}Python3 is already installed${N}"
else
    dnf install python3 -y
    Validate $? "Python3"
fi