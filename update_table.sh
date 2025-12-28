#!/bin/bash

DB_PATH=$1

echo "Table name:"
read table

META="$DB_PATH/$table.meta"
DATA="$DB_PATH/$table.data"

if [ ! -f "$META" ]; then
    echo "Table not found"
    return
fi

cols=()
types=()
pk_index=-1
i=0

while IFS=':' read c t k
do
    cols[$i]=$c
    types[$i]=$t

    if [ "$k" = "PK" ]; then
        pk_index=$i
    fi

    i=$((i+1))
done < "$META"

clear
echo "Choose column to search by:"
i=0
for c in "${cols[@]}"
do
    echo "$i) $c"
    i=$((i+1))
done

read col_index

clear
echo "Enter value to search:"
read search_value

tmp="$DATA.tmp"
> "$tmp"

while IFS='~' read -a row
do
    if [ "${row[$col_index]}" = "$search_value" ]; then

        newline=""

        for i in "${!cols[@]}"
        do
            echo "New ${cols[$i]} (${types[$i]}) [ENTER = keep]:"
            read val < /dev/tty

            if [ -z "$val" ]; then
                val="${row[$i]}"
            else
                if [ "${types[$i]}" = "int" ]; then
                    expr "$val" + 0 >/dev/null 2>&1
                    if [ $? -ne 0 ]; then
                        echo "Invalid integer"
                        val="${row[$i]}"
                    fi
                fi
        	if [ "$i" -eq "$pk_index" ]; then
            		if [ -f "$DATA" ]; then
                		if cut -d'~' -f1 "$DATA" | grep -x "$val" >/dev/null 2>&1; then
                    			echo "Primary key must be unique no change happened"
                    			val="${row[$i]}"
               	 		fi
            		fi
        	fi                
            fi

            if [ -z "$newline" ]; then
                newline="$val"
            else
                newline="$newline~$val"
            fi
        done

        echo "$newline" >> "$tmp"
    else
        Tem2=""
    	for i in "${!cols[@]}"
        do
        
            if [ -z "$Tem2" ]; then
                Tem2="${row[$i]}"
            else
                Tem2="$Tem2~${row[$i]}"
            fi
        done
        echo "$Tem2" >>"$tmp"	
    fi
done < "$DATA"

mv "$tmp" "$DATA"
clear
echo "Update finished"



