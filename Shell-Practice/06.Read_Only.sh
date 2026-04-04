#!/bin/bash
#ReadOnly Variable
readonly Pi=3.14
function1(){
    echo "Iam in function1 and my Pi is $Pi"
}
function2(){
    echo "Iam in function2 and my Pi is $Pi"
}
echo "Iam in main and my Pi is $Pi"
function1
function2       