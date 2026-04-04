#!/bin/bash
USERID=$(id -u)
if [ $USERID -eq 0 ]; then
    echo "You are root user, you can install the software"
else
    echo "Please run this with Root Privileges"
    exit 1
fi

dnf install mysql -y
if [ $? -eq 0 ]; then
    echo "MySQL installed successfully"
else
    echo "Failed to install MySQL"
fi
