#!/bin/bash
USERID=$(id -u)
#Check if the user is root or not
R="\e[31m" #Red Color
G="\e[32m" #Green Color
Y="\e[33m" #Yellow Color
N="\e[0m" #Normal Color
if [ $USERID -eq 0 ]; then
    echo "You are root user, you can install the software"
else
    echo "Please run this with Root Privileges"
    exit 1
fi

#Function to validate the installation of software
Validate(){
    dnf install mysql -y
    if [ $1 -eq 0 ]; then
        echo "$2 installed successfully"
    else
        echo "Failed to install $2"
        exit 1
    fi
}
#Install MySQL, NGINX and MONGOSH
dnf install mysql -y
Validate $? "MYSQL"

dnf install nginx -y
Validate $? "NGINX"

dnf install python3 -y
Validate $? "Python3"