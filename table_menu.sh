#!/bin/bash

db=$1
DB_PATH="./databases/$db"
clear
while true; do
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
        	source list_tables.sh  "$DB_PATH"
		source create_table.sh  "$DB_PATH"
		
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
        	source list_tables.sh "$DB_PATH"
            	source select_from_table.sh "$DB_PATH"
            ;;

        6)
        	source list_tables.sh "$DB_PATH"
            	source delete_from_table.sh "$DB_PATH"
            ;;

        7)
	    source list_tables.sh "$DB_PATH"
    	    source update_table.sh "$DB_PATH"
            ;;

        8)
            return
            ;;

        *)
            echo "Invalid choice!"
            ;;
    esac
done
