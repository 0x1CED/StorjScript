#!/bin/bash

#Simple Uploader for linux. Place inside libstorj/bin
# The script will create a new directory with randomly generated files, and begin uploading
# Files are automatically removed after uploading.
BUCKET=<bucket>
PASSWORD=<password>
#generates a 16 character unique filename
FILENAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16 ; echo '')
#Create Directory to store files in
mkdir upload_files
FILENAME="upload_files/$FILENAME"
echo File name $FILENAME

#creates a 1 gig file. Modify to your suiting
dd if=/dev/urandom of=$FILENAME bs=1024 count=1M

while :
do
	echo Bucket: $BUCKET
	#change the hash by adding a character
	echo a >> $FILENAME
	RESULT=$(echo $PASSWORD | ./storj upload-file $BUCKET $FILENAME) 
	echo $RESULT
	FILE_ID=$(echo $RESULT | grep -o -w '\w\{24\}')
	echo File ID: $FILE_ID
	echo $PASSWORD | ./storj remove-file $BUCKET $FILE_ID
done
