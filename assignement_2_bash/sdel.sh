#! /bin/bash

clear
trash_location=~/TRASH
#Handling the trash location
if [ -d $trash_location ]
then 
	echo "Trash location exists."
else
	echo "Trash location doesn't exist, creating new one..."
	mkdir $trash_location && echo "directory $trash_location has been created"
	chmod -R 777 $trash_location
	(crontab -l 2>/dev/null; echo "0 5,17 * * * sdel.sh") | crontab - #this runs twice a day 5AM and 5PM
fi
find $trash_location -type f -mtime +2 -exec rm -f {} \; #this line finds the files those spent 48 hours in the TRASH directory and deletes them

#Reading the arguments to the script
if [ $# -eq 0 ] 
then 
	echo "Wrong usage of the command"
	echo "usage: bash [script name] [FILES] "
else
	echo "Correct usage of the command"	
	#here we loop on all the files in the command
	for i in $@
	do
		if [ -d $i ] #check if it's a directory .. do the operation recursively
		then			
			echo "this is a directory"
			directory=$i
			if [ -e $directory.*.gz ]
			then 
				echo "COMPRESSED DIRECTORY ALREADY EXISTS>>$directory"
			else
				gzip -r $directory && echo "internal zipping is complete"				
				tar czvf $directory.tar.gz $directory && echo "The directory itself has been compressed"
				mv $directory.tar.gz $trash_location && echo "The compressed directory $directory.tar.gz has been moved to the trash."	
			fi

		elif [ -e $i ] #check if it's a file .. do the operation
		then
			echo "This is a file"

			file=$i
			if [ -e $file.*gz ]
			then 
				echo "COMPRESSED FILE ALREADY EXISTS"
			else
				tar czf $file.tar.gz $file && echo "The file has been compressed"
			fi

			mv $file.tar.gz $trash_location && echo "The compressed file $file.tar.gz has been moved to the trash."
	
		else
			echo "This file doesn't exist"
		fi		
	done
fi
