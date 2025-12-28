db=$1
echo "enter the table name or (:q) to return to table menu: :"
read tname
[ "$tname" = ":q" ] && clear && return 
if [ -f "$db/$tname.data" ]
then
	clear
	echo "these are the columns in $tname :"
	awk -F: '{print $1}' $db/$tname.meta
	echo "enter the column names (comma-separated) :"
	read cols
	if [ "$cols" = "*" ]
	then
		select_all=true
	else
		select_all=false
		IFS=',' read -ra col_arr <<< "$cols"
		        fields_to_print=()
        for c in "${col_arr[@]}"
        do
            if ! grep -q "^$c:" "$db/$tname.meta"; then
                clear
                echo "column $c doesn't exist"
                return
            fi
            counter=1
            while read line; do
                colname=$(echo "$line" | cut -d: -f1)
                if [ "$colname" = "$c" ]; then
                    fields_to_print+=("$counter")
                    break
                fi
                counter=$((counter + 1))
            done < "$db/$tname.meta"
        done
    fi
	echo "do you want to filter rows (condition) ?"
	read ans
	if [ "$ans" = "yes" ]
	then
		echo "write the condition(column operator value) , operator should be (> , < , =) for int , (=) for string"
		read  col op val
		counter=1
		field_number=""
        while read line; do
            colname=$(echo "$line" | cut -d: -f1)
            datatype=$(echo "$line" | cut -d: -f2)
            if [ "$col" = "$colname" ]; then
                field_number=$counter
                col_datatype="$datatype"
                break
            fi
            counter=$((counter + 1))
        done < "$db/$tname.meta"

	if [ -z "$field_number" ]; then
	    clear
            echo "column '$col' not found "
            return 
        fi
	fi

else
	clear
	echo "table $tname doesn't exist"
	return
fi
found=false
clear
while read line
do
	match=true
	if [ "$ans" = "yes" ]
	then
        	value=$(echo "$line" | cut -d~ -f$field_number)
        	match=false
	if [ "$col_datatype" = "int" ]; then
		  if ! [[ "$value" =~ ^-?[0-9]+$ && "$val" =~ ^-?[0-9]+$ ]]; then
                continue
            fi
        if [ "$op" = "=" ] && [ "$value" -eq "$val" ]; then
           match=true
        elif [ "$op" = ">" ] && [ "$value" -gt "$val" ]; then
           match=true
        elif [ "$op" = "<" ] && [ "$value" -lt "$val" ]; then
            match=true
        fi
    else 
        if [ "$op" = "=" ] && [ "$value" = "$val" ]; then
            match=true
        fi
    fi
	fi
  
     if [ "$match" = true ]; then
	      found=true
        if [ "$select_all" = true ]; then
            echo "$line"
        else
            output=""
            for f in "${fields_to_print[@]}"; do
                field_val=$(echo "$line" | cut -d~ -f$f)
                output+="$field_val "
            done
            echo "${output}" 
        fi
    fi
	 
done < "$db/$tname.data"
if [ "$ans" = "yes" ] && [ "$found" = false ]; then
    echo "no rows with this value"
fi

