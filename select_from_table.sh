echo "enter the table name :"
read tname
if [ -f "$tname.data" ]
then
	echo "enter the column names (comma-separated) :"
	read cols
	if [ $cols = '*' ]
	then
		select_all = true
	else
		select_all = false
		IFS=',' read -ra col_arr <<< "$cols"
		for c in "${col_arr[@]}"
		do
			if ! grep -q "^$c:" "$tname.meta"
			then
				echo "column $c doesn't exist"
				exit
			fi
		done
	fi
	echo "do you want to filter rows (condition) ?"
	read $ans
	if [ $ans = 'yes' ]
	then
		echo "write the condition like (column operator value) , operator should be (> , < , =) only"
		read $cond
	else
		break
	fi

else
	echo "table $tname doesn't exist"
	exit
fi

