#!/bin/bash
HOME=`pwd`
mkdir _temp_for_certificate
cd _temp_for_certificate
count=0
while [ -n "$1" ]
do
	FILE=$1
	if [ ! -f $FILE ]; then
		FILE=$HOME/$1
	fi
	count=$[$count+1]
	echo "(#$count) "`basename "$1"`":"
	echo ""
	rsapath=`jar tf "$FILE" | grep RSA`	# find RSA file in apk
	echo $rsapath
	jar xf $FILE $rsapath 			# extract RSA file
	keytool -printcert -file $rsapath 	# check key file
	rm -r $rsapath 				# delete file
	echo "--------------------------------------------"
	shift
done
cd ..
rm -r _temp_for_certificate 
