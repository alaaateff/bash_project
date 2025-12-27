#!/bin/bash

db=$1
DB_PATH="./databases/$db"
clear
while true; do
    echo
    echo "===== Table Menu ($db) ====="
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Drop Table"
    echo "4. Insert into Table"
    echo "5. Select From Table"
    echo "6. Delete From Table"
    echo "7. Update Table"
    echo "8. Back to Main Menu"
    read -p "Enter your choice: " choice

    case $choice in
        1)
		source create_table.sh  "$DB_PATH"
		clear
		echo "Table created"
            ;;

        2)
		source list_tables.sh  "$DB_PATH"

            ;;

        3)
	
		source list_tables.sh  "$DB_PATH"
		source drop_table.sh  "$DB_PATH"
		clear
		echo "Table dropped"

            ;;

        4)
           	source list_tables.sh "$DB_PATH"
    		source insert_into_table.sh "$DB_PATH"
            ;;

        5)
            read -p "Enter table name: " table
            data="$DB_PATH/$table.txt"
            meta="$DB_PATH/$table.meta"
            if [ ! -f "$data" ]; then
                echo "Table not found!"
                continue
            fi
            read -a cols < <(sed -n '1p' "$meta")
            # Print header
            for c in "${cols[@]}"; do
                printf "%-15s" "$c"
            done
            echo
            printf '%0.s-' {1..80}; echo
            # Print rows
            while IFS=',' read -ra row; do
                for v in "${row[@]}"; do
                    printf "%-15s" "$v"
                done
                echo
            done < "$data"
            ;;

        6)
            read -p "Enter table name: " table
            data="$DB_PATH/$table.txt"
            meta="$DB_PATH/$table.meta"
            if [ ! -f "$data" ]; then
                echo "Table not found!"
                continue
            fi

            read -a cols < <(sed -n '1p' "$meta")
            pk=$(sed -n '3p' "$meta")
            read -p "Enter $pk value to delete: " val
            if grep -q "^$val," "$data"; then
                grep -v "^$val," "$data" > "$data.tmp" && mv "$data.tmp" "$data"
                echo "Row deleted."
            else
                echo "Row not found!"
            fi
            ;;

        7)
            read -p "Enter table name: " table
            data="$DB_PATH/$table.txt"
            meta="$DB_PATH/$table.meta"
            if [ ! -f "$data" ]; then
                echo "Table not found!"
                continue
            fi

            read -a cols < <(sed -n '1p' "$meta")
            read -a types < <(sed -n '2p' "$meta")
            pk=$(sed -n '3p' "$meta")
            read -p "Enter $pk value to update: " val

            # Find row number
            rownum=$(grep -n "^$val," "$data" | cut -d: -f1)
            if [ -z "$rownum" ]; then
                echo "Row not found!"
                continue
            fi

            declare -a newrow
            for i in "${!cols[@]}"; do
                while true; do
                    read -p "Enter new value for ${cols[i]} (${types[i]}): " v
                    if [[ ${types[i]} == "int" && ! "$v" =~ ^-?[0-9]+$ ]]; then
                        echo "Invalid integer!"
                        continue
                    fi
                    if [[ ${cols[i]} == "$pk" && "$v" != "$val" && $(grep -c "^$v," "$data") -gt 0 ]]; then
                        echo "Primary key value already exists!"
                        continue
                    fi
                    newrow[i]="$v"
                    break
                done
            done
            IFS=','; newline="${newrow[*]}"; unset IFS
            sed -i "${rownum}s/.*/$newline/" "$data"
            echo "Row updated."
            ;;

        8)
            break
            ;;

        *)
            echo "Invalid choice!"
            ;;
    esac
done
