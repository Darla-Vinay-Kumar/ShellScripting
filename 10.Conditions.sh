#!/bin/bash
echo "Please enter the number"
read Number
if [ $(($Number % 2)) -eq 0 ]; then
    echo "The Given $Number is even"
else
    echo "The Given $Number is odd"
fi  