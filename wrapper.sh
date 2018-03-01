#!/bin/bash

i=1
while [ $i -le $# ]; do
	ITEM="${!i}"
	echo "$ITEM" | grep -q " "
	if [ $? -eq 0 ]; then
		PARAM="$PARAM \"$ITEM\""
	else
		PARAM="$PARAM $ITEM"
	fi
	i=`expr $i + 1`
done

echo $PARAM
