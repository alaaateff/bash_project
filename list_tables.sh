#!/bin/bash
clear
db=$1

if ls  $db/*.data >/dev/null 2>&1; then
    ls  $db/*.data |cut -d '/' -f4 | cut -d '.' -f1 
else
    echo "this database is empty"
fi
