db=$1
echo "enter table name or (:q) to return to table menu: "
read tname
[ "$tname" = ":q" ] && clear && return 
if [ ! -f "$db/$tname.data" ] || [ ! -f  "$db/$tname.meta" ]
then
        echo "this table doesn't exist"
        exit
else
	clear
        echo -e "\nChoose delete option:"
        select choice in "delete whole table" "delete row based on primary key" "delete rows based on specific value of column "
        do
        case $REPLY in
                1) 
                	touch "$db/temp"
                	mv "$db/temp" "$db/$tname.data" 
                	clear
                        echo "$tname table deleted successfully"
                        break;;
                2) pk=$(awk -F: '$3 !="" { print $1; exit}' $db/$tname.meta)
                        echo "primary key is $pk , enter the value you want : "
                        read val
                        original_lines=$(wc -l < "$db/$tname.data")
                        pk_field=$(awk -F: -v pk="$pk" '$1==pk { print NR }' $db/$tname.meta)
                        awk -F~ -v f=$pk_field -v v="$val" '$f != v { print }' $db/$tname.data > $db/newfile
                        new_lines=$(wc -l < $db/newfile)
                        if [ "$new_lines" -eq "$original_lines" ]; then
                        	  clear
                                  echo "No rows found , nothing deleted."
                                  echo "1)delete whole table" 
                                  echo "2)delete row based on primary key" 
                                  echo "3)delete rows based on specific value of column"
                                  rm $db/newfile
                        else
                                mv $db/newfile $db/$tname.data
                                clear
                                echo "Rows deleted successfully"
                                break
                        fi
                        ;;
                3) 
                	clear
                	echo "these are the columns in $tname :"
                        awk -F: '{print $1}' $db/$tname.meta
                        echo "enter the column you want to delete from"
                        read col
                        echo "enter the value you want : "
                        read value
                        original_lines=$(wc -l < "$db/$tname.data")
                        col_field=$(awk -F: -v col="$col" '$1==col { print NR }' $db/$tname.meta)
                        if [ -z "$col_field" ]; then
                               clear
                               echo "Column '$col' does not exist!"
                               break
                        fi
                        awk -F~ -v f=$col_field -v v="$value" '$f != v { print }' $db/$tname.data > $db/newfile
                        new_lines=$(wc -l < "$db/newfile")
                        if [ "$new_lines" -eq "$original_lines" ]; then
                                 echo "No rows found , nothing deleted."
                                  rm $db/newfile
                        else
                                mv $db/newfile $db/$tname.data
                                clear
                                echo "Rows deleted successfully"
                                break

                        fi
                 ;;
                *) echo "$REPLY is not one of the choices try again "
                        ;;
        esac
done

fi





