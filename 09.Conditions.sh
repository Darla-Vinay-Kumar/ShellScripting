#!/bin/bash
Number=$1
# -gt Greater than
# -lt Less than
# -eq Equal to
# -ne Not Equal to
if [ $Number -lt 10 ]; then
    echo "The Given $Number is less than 10"
elseif [ $Number -eq 10 ]; then
    echo "The Given $Number is equal to 10" 
else
    echo "The Given $Number is greater than 10"
fi