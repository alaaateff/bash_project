if [ "$(ls -A)" ]
then
	ls *.data | cut -d'.' -f1
else
	echo "this database is empty"
fi
