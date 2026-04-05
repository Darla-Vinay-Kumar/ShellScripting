#!/bin/bash
echo "This is a trap command example"
error(){
    echo "An error occurred at line $LINENO while executing: $BASH_COMMAND"
}
trap error ERR
echo "before error"
ashdc
echo "after error"