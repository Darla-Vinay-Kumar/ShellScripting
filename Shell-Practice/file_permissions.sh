#!/bin/bash

File=$1
if [ -f $File ]; then
    echo "The Given $File is a existing regular file"
    if [ -r $File ] && [ -w $File ]; then
        echo "The Given $File has read and write permission"
    else
        echo "The Given $File does not have read and write permission"
    fi
elif [ -d $File ]; then
    echo "The Given $File is a existing directory"
    for file in "$File"/*; do
        if [ -f $file ]; then
            echo "The Given $file is a existing regular file"
            if [ -r $file ] && [ -w $file ]; then
                echo "The Given $file has read and write permission"
            else
                echo "The Given $file does not have read and write permission"
            fi
        else
            echo "The Given $file is not a existing regular file"
        fi
    done
else
    echo "The Given $File is not a existing regular file or directory"
fi
