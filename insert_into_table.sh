#!/bin/bash

DB_PATH=$1

echo "Enter table name to insert into or (:q) to return to table menu:"
read table
[ "$table" = ":q" ] && clear && return 
META_FILE="$DB_PATH/$table.meta"
DATA_FILE="$DB_PATH/$table.data"

if [ ! -f "$META_FILE" ]; then
    echo "Table does not exist!"
    return
fi

row=""

while read line
do
    col_name=$(echo "$line" | cut -d':' -f1)
    col_type=$(echo "$line" | cut -d':' -f2)
    col_pk=$(echo "$line" | cut -d':' -f3)

    while true
    do
        echo "Enter value for $col_name ($col_type):"
        read value < /dev/tty

        if [ -z "$value" ]; then
            echo "Value cannot be empty"
            continue
        fi

        if [ "$col_type" = "int" ]; then
            expr "$value" + 0 >/dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo "Invalid integer"
                continue
            fi
        fi

        if [ "$col_pk" = "PK" ]; then
            if [ -f "$DATA_FILE" ]; then
                if cut -d'~' -f1 "$DATA_FILE" | grep -x "$value" >/dev/null 2>&1; then
                    echo "Primary key must be unique"
                    continue
                fi
            fi
        fi

        break
    done

    if [ -z "$row" ]; then
        row="$value"
    else
        row="$row~$value"
    fi

done < "$META_FILE"

echo "$row" >> "$DATA_FILE"
clear
echo "Row inserted successfully"

