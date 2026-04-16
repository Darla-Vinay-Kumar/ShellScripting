# Shell Scripting for DevOps Automation 

This repository contains practical shell scripting examples created while learning and implementing DevOps concepts.

The main purpose of this repository is to demonstrate how shell scripting can be used to automate repetitive Linux and system administration tasks such as software installation, service configuration, file handling, and application setup.

The repository is divided into two main parts:

1. shell_practice → Covers fundamental shell scripting concepts
2. shell_robo → Contains real-time automation scripts inspired by microservices architecture deployment

This repository reflects hands-on practice with Linux commands, Bash scripting logic, and DevOps-style automation.

---

# Repository Structure

## shell_practice

This folder contains scripts focused on learning and understanding core shell scripting concepts.

Each script demonstrates a specific concept required for writing automation scripts.

Topics covered include:

Variables
How to store and use values in scripts.

User Input
Accepting input from terminal during script execution.

Conditional Statements
Using if, else, elif conditions to make decisions in scripts.

Loops
Using for loops to repeat tasks multiple times.

Functions
Creating reusable blocks of code inside scripts.

Command Line Arguments
Passing values while executing scripts.

Arrays
Handling multiple values in a single variable.

File Checks
Checking whether a file or directory exists.

Text Processing
Using Linux utilities such as grep, awk, and cut to filter and extract data.

Cron Job Example
Automating script execution using scheduling.

These scripts help in understanding how logic can be written in Bash to automate manual work.

---

## shell_robo

This folder contains automation scripts inspired by real-time microservices-based application deployment.

Each script performs installation and configuration of a particular service required for application setup.

The scripts demonstrate:

Installing required packages
Creating application users
Setting up directories
Configuring services
Starting and enabling services
Managing dependencies

Services included in this section:

Frontend service setup using nginx
MongoDB database setup
Catalogue service setup
Redis installation and configuration
User service setup
Cart service setup
MySQL database setup
Shipping service setup
RabbitMQ installation
Payment service setup

These scripts simulate how DevOps engineers automate environment setup for applications.

---

# Skills Demonstrated

Linux command usage
Bash scripting
Automation of repetitive tasks
Service management using systemctl
Package installation using dnf or yum
Basic microservices environment setup
Script structuring and reusability
Problem solving using scripting logic

---

# Technologies Used

Linux
Bash
Systemctl
DNF package manager
Text processing tools (grep, awk, cut)

---

# How to Execute Scripts

Step 1: Navigate to script location

cd shell_practice

Step 2: Give execute permission

chmod +x scriptname.sh

Step 3: Run script

./scriptname.sh

Example:

chmod +x 01_variables.sh
./01_variables.sh

---

# Why this repository is useful

Shell scripting is widely used in DevOps for automating:

Server configuration
Application deployment
Log cleanup
Backup processes
Monitoring scripts
User management
Service restart automation
Environment setup

This repository shows practical understanding of these tasks.

---

# Future Improvements

Adding more real-time automation scripts
Integrating scripts with Ansible
Creating reusable script templates
Adding logging and error handling
Creating environment setup automation scripts

---

# Author

Vinay Kumar
DevOps / DevSecOps Engineer
Interested in Automation, Cloud and Infrastructure

---
