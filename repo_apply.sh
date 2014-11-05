ROOT_DIR=$1
FILE=$2

PRJ_DIR=
PRJ_LINE_START=
LINE_NUM=0

LINE_TOTAL=`wc -l $FILE | cut -d' ' -f 1`
#echo $LINE_TOTAL

function apply_patch
{
	VAR_LINE_START=$1
	VAR_LINE_END=$2
	VAR_DIR=$3

	TMPFILE=`echo $VAR_DIR | sed -e "s/\//_/g"`".tmp"

	sed -n ${VAR_LINE_START},${VAR_LINE_END}p $FILE > $TMPFILE

	echo "Apply patch '$TMPFILE' to '$VAR_DIR'"
	VAR_HOME=`pwd`
	cd $ROOT_DIR/$VAR_DIR
	patch -Np1 < $VAR_HOME/$TMPFILE
	cd $VAR_HOME
	rm -f $TMPFILE
}

while [ $LINE_NUM -le $LINE_TOTAL ] 
do
	LINE_NUM=`expr $LINE_NUM + 1`
	LINE=`sed -n ${LINE_NUM}p $FILE`
	PRJ_SIG=`echo "$LINE" | grep ^project.*\/$` 
	if [ "$PRJ_SIG" != "" ]; then
		DIR=`echo $LINE | cut -d' ' -f 2`
		#echo "Found prject: $DIR on line: $LINE_NUM"
		# apply patch and clear tmp file
		if [ "$PRJ_DIR" != "" ]; then
			PRJ_LINE_END=`expr $LINE_NUM - 1`
			apply_patch $PRJ_LINE_START $PRJ_LINE_END $PRJ_DIR 
		fi
		# if no folder, omit this patch
		if [ ! -d $ROOT_DIR/$DIR ]; then
			echo Folder not exist: $DIR
			PRJ_DIR=""
		else
			PRJ_DIR=$DIR;
			PRJ_LINE_START=`expr $LINE_NUM + 1`
		fi
	fi
done
# apply last patch
apply_patch $PRJ_LINE_START $LINE_TOTAL $PRJ_DIR

