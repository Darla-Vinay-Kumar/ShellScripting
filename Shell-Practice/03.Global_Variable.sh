#!/bin/bash
#Global Variable
Name="Raja"
function1(){
    echo "Iam in function1 and my name is $Name"
}
function2(){
    echo "Iam in function2 and my name is $Name"
}
echo "Iam in main and my name is $Name"
function1
function2    