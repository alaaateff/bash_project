#!/bin/bash
clear
db=$1

echo "enter table name : "
read tname
count=0
for files in `ls -f $db`
do
	files=$(basename "$files")
        if [ "$files"  = "$tname" ]
        then
                echo "this table exists"
                count=$((count+1))
		break
	fi
done
if [ $count -eq 0 ]
then
        touch $db/$tname.data
	touch $db/$tname.meta

echo "enter your columns and when you finish enter done: "
read col 
while [ "$col" != "done" ]
do
		while [ "$col" = "" ]
		do
		echo "you entered empty column try again"
		read col
	done 
       	while grep "$col" $db/$tname.meta >/dev/null
	do
			echo "you can't insert the column twice , enter another column"
			read col
	done
echo "what datatype of "$col"? valid datatypes are int and string only"
read dt
while [ "$dt" != "int" -a "$dt" != "string" ]
do
	echo "invalid datatype try again"
	read dt
done
       echo "$col:$dt" >> $db/$tname.meta
echo "enter your another column and if you finish  enter done: "
read col
done
fi
echo "which column you want to be primary key of the table ?"
read pk
while ! grep "$pk" $db/$tname.meta >/dev/null
do
	echo "this column isn't exist! enter another column :"
	read pk
done
sed -i "/^$pk:/ s/$/:PK/" $db/$tname.meta



