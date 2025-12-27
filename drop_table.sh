db=$1

echo "enter table name you want to drop :"
read table
while [ ! -f "$db/$table.data" ]
do
	echo "this table isn't exist! enter another one : "
	read table
done
rm "$db/$table.data" "$db/$table.meta"
