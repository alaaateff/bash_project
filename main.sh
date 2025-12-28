#!/bin/bash

DB_PATH="./databases"
mkdir -p "$DB_PATH"
clear
while true; do
    echo "===== Main Menu ====="
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            clear
            read -p "Enter database name or (:q) to return to main menu: " db
            [ "$db" = ":q" ] && clear && continue 
            if [ -d "$DB_PATH/$db" ]; then
            	clear
                echo "Database '$db' already exists!"
            else
            	clear
                mkdir -p "$DB_PATH/$db"
                echo "Database '$db' created."
            fi
            ;;
        2)
            clear
            echo "Databases:"
            ls "$DB_PATH"
            ;;
        3)
            clear
            echo "Databases:"
            ls "$DB_PATH"
            read -p "Enter database name to connect or (:q) to return to main menu: " db
            [ "$db" = ":q" ] && clear && continue 
            if [ -d "$DB_PATH/$db" ]; then
                # Call table menu script
                source table_menu.sh "$db"
                DB_PATH="./databases"
                clear
            else
                clear
                echo "Database not found!"
            fi
            ;;
        4)
            clear
            echo "Databases"
            
            
            ls "$DB_PATH"
            read -p "Enter database name to drop or (:q) to return to main menu: " db
            [ "$db" = ":q" ] && clear && continue 
            if [ -d "$DB_PATH/$db" ]; then
                rm -r "$DB_PATH/$db"
                clear
                echo "Database '$db' deleted."
            else
                clear
                echo "Database not found!"
            fi
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            clear
            echo "Invalid choice!"
            ;;
    esac
done


