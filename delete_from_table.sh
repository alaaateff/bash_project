db=$1
echo "enter table name : "
read tname
if [ ! -f "$db/$tname.data" ] || [ ! -f  "$db/$tname.meta" ]
then
	echo "this table doesn't exist"
	exit
else
	echo -e "\nChoose delete option:"
	select choice in "delete whole table" "delete row based on primary key" "delete rows based on specific value of column "
	do
	case $REPLY in
		1) rm $db/$tname.data
			echo "$tname table deleted successfully"
			break;;
		2) pk=$(awk -F: '$3 !="" { print $1; exit}' $db/$tname.meta)
			echo "primary key is $pk , enter the value you want : "
			read val
			pk_field=$(awk -F: -v pk="$pk" '$1==pk { print NR }'$db/$tname.meta)
			awk -F~ -v f=$pk_field -v v="$val" '$f != v { print }'$db/$tname.data > $db/newfile
			if [ ! -s $db/newfile ]
			then
				echo "no rows with $val"
				rm $db/newfile
			else
				mv $db/newfile $db/$tname.data
                                echo "Row deleted successfully"
				break

			fi
	        	;;
  	        3) echo "these are the columns in $tname :"
                        awk -F: '{print $1}' $db/$tname.meta
		       	echo "enter the column you want to delete from"
			read col
	        	echo "enter the value you want : "
			read value
			col_field=$(awk -F: -v col="$col" '$1==col { print NR }' $db/$tname.meta)
			if [ -z "$col_field" ]; then
                               echo "Column '$col' does not exist!"
                               break
                        fi
			awk -F~ -v f=$col_field -v v="$value" '$f != v { print }' $db/$tname.data > $db/newfile
			if [ ! -s $db/newfile ]
                        then
                                echo "no rows with $val"
                                rm $db/newfile
                        else
                                mv $db/newfile $db/$tname.data
                                echo "Rows deleted successfully"
                                break

                        fi
                        ;;	
		*) echo "$REPLY is not one of the choices try again "
			;;
	esac
done
fi





