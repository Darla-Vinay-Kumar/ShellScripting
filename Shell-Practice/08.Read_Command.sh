#!/bin/bash
#Read keyword
echo "Enter your name"
read Name
echo "Your name is $Name"

#---Read without showing inputs (Password)---
echo "Enter your password"
read -s Password
echo "Your password is $Password"   

#---Read with a prompt message---
read -p "Enter your name: " Name
echo "Your name is $Name"  

#---Read with a timeout---
read -t 10 -p "Enter your name within 10 seconds: " Name
if [ $? -eq 0 ]; then
    echo "Your name is $Name"
else
    echo "Time out! You did not enter your name within 10 seconds."
fi      
#---Read multiple variables---
read -p "Enter your first name and last name: " FirstName LastName
echo "Your first name is $FirstName and your last name is $LastName"    


