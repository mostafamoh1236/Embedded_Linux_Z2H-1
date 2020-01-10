#! /bin/bash

clear
flag="0"
reg='^[0-9]+$'
#path=$(pwd)
path=~
echo "THIS IS HAZEM'S PHONE BOOK"

#create the portable file in user's home
if [ -d $path/phonebook ] #checking whether the directory exists or not
then
	echo "directory phonebook exists."
	directory=$path/phonebook
else
	echo "directory phonebook doesn't exist, creating one new one..."
	mkdir $path/phonebook
	chmod -R u+r $path/phonebook
	directory=$path/phonebook
fi

#Loading the database
if [ -e $directory/.phonebookDB.txt ] #checking whether the file exists or not
then
	echo "file .phonebookDB.txt exists."
	file=$directory/.phonebookDB.txt
else
	echo "file .phonebookDB.txt doesn't exist, creating one new one..."
	touch $directory/.phonebookDB.txt
	chmod 777 $directory/.phonebookDB.txt
	file=$directory/.phonebookDB.txt
fi
option=$1
#checking on the first command argument
if [ "$option" == "-i" ] #insert a new contact
then
	echo "inserting new contact.."
	read -p "Name: " contact_name
	read -p "Number: " phone_number
	while [ "$flag" -eq "0" ]
	do 	
		if [[ ! $phone_number =~ $reg ]]
		then
			echo 'The format is wrong'
			read -p "Number: " phone_number
		else
			echo 'correct format'
			flag=1
		fi
	done
	echo
	echo -n "$contact_name: $phone_number " >> $file
	flag="0"
	while [ "$flag" -eq "0" ]
	do
		read -p "Do you want to add another number for this contact?[y/n]: " check
		if [ "$check" == "y" ]
		then
			read -p "Number: " phone_number
			while [ "$flag" -eq "0" ]
			do 	
				if [[ ! $phone_number =~ $reg ]]
				then
					echo 'The format is wrong'
					read -p "Number: " phone_number
				else
					echo 'correct format'
					flag=1
				fi
			done
			#append the other number in the same line
			echo " - $phone_number " >> $file
			flag="0"
		elif [ "$check" == "n" ]
		then
			echo "Contact has been added to the database."
			flag=1
		else
			echo "Wrong selection."
		fi
	done	

elif [ "$option" == "-v" ] #view all existing contacts
then
	echo "view all"
	less $file
	
elif [ "$option" == "-s" ] #search on a certain contact by name
then
	echo "search"
	read -p "Name: " search_name
	pattern="^$search_name:"
	echo
	echo
	grep -E $"$pattern" $file

elif [ "$option" == "-e" ] #deletes all the existing contacts
then
	echo "delete all"
	cat /dev/null > $file

elif [ "$option" == "-d" ] #deletes a certain contact
then
	echo "deleting only one..."

	read -p "Name: " search_name
	pattern="^$search_name:" #regex pattern
	grep -v -E $"$pattern" $file > temp && mv temp $file
	echo "Contact has been deleted from the database."

else #in case of a wrong argument selection, it prints the valid choices for the command arguments
	echo 'usage: bash filename [option]'
	echo
	echo '-i -> to insert new contact'
	echo '-v -> to view contacts'
	echo '-s -> to search for a certain contact'
	echo '-e -> to delete all contacts'
	echo '-d -> to delete a certain contact'
fi
