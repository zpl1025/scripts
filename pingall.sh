#!/bin/bash

# for english locale only...

TMPFILE_PREFIX="__myping_tmp_file"
IPSEG="192.168.88"
IPMIN=2
IPMAX=254

echo "looking host from $IPSEG"."$IPMIN to $IPSEG"."$IPMAX ..."

myping()
{
	ping -c 1 -t 1 $IPSEG"."$i | grep "bytes from" > $TMPFILE_PREFIX"_out_"$i
	touch $TMPFILE_PREFIX"_done_"$i
}

i=$IPMIN; 
out=()
done=()
while [ $i -le $IPMAX ]; do 
	myping $i &
	i=`expr $i + 1`
done

# collect information
i=$IPMIN;
while [ $i -le $IPMAX ]; do
	if [ ! -f $TMPFILE_PREFIX"_done_"$i ]; then
		#echo waiting $i
		sleep 1
		continue
	fi
	cat $TMPFILE_PREFIX"_out_"$i >> $TMPFILE_PREFIX".sum"
	i=`expr $i + 1`
done

cat $TMPFILE_PREFIX".sum" | cut -d':' -f 1 | cut -d' ' -f 4

rm "$TMPFILE_PREFIX"*
