#!/bin/bash
echo "This is a trap command example"
error(){
    echo "An error occurred at line $1 while executing: $2"
}
trap error ERR
echo "before error"
ashdc
echo "after error"