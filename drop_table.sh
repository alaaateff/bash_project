echo "enter table name you want to drop :"
read table
while [ ! -f "$table.data" ]
do
	echo "this table isn't exist! enter another one : "
	read table
done
rm "$table.data" "$table.meta"
