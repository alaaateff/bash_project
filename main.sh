#!/bin/bash

DB_PATH="./databases"
mkdir -p "$DB_PATH"

while true; do
    echo
    echo "===== Main Menu ====="
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter database name: " db
            if [ -d "$DB_PATH/$db" ]; then
                echo "Database '$db' already exists!"
            else
                mkdir -p "$DB_PATH/$db"
                echo "Database '$db' created."
            fi
            ;;
        2)
            echo "Databases:"
            ls "$DB_PATH"
            ;;
        3)
            read -p "Enter database name to connect: " db
            if [ -d "$DB_PATH/$db" ]; then
                # Call table menu script
                source table_menu.sh "$db"
            else
                echo "Database not found!"
            fi
            ;;
        4)
            read -p "Enter database name to drop: " db
            if [ -d "$DB_PATH/$db" ]; then
                rm -r "$DB_PATH/$db"
                echo "Database '$db' deleted."
            else
                echo "Database not found!"
            fi
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac
done

