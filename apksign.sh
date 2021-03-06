#!/bin/bash

if [[ "$1" != "_"  &&  -d $1 ]];then
	ANDROID_ROOT=$1
else
	echo "Unknow Platform..."
	echo "user: sig.sh android_sdk_path apk "
	exit -1;
fi

X509=$ANDROID_ROOT/build/target/product/security/platform.x509.pem
PK8=$ANDROID_ROOT/build/target/product/security/platform.pk8
X509s=$ANDROID_ROOT/build/target/product/security/shared.x509.pem
PK8s=$ANDROID_ROOT/build/target/product/security/shared.pk8
X509m=$ANDROID_ROOT/build/target/product/security/media.x509.pem
PK8m=$ANDROID_ROOT/build/target/product/security/media.pk8
SIGNAPK=$ANDROID_ROOT/out/host/linux-x86/framework/signapk.jar

if [ ! -f "$X509" ];then
	echo "$X509 is no exist..."
	exit -1;
fi
if [ ! -f "$PK8" ];then
	echo "$PK8 is no exist..."
	exit -1;
fi
if [ ! -f "$SIGNAPK" ];then
	echo "$SIGNAPK is no exist..."
	exit -1;
fi
if [ -f "$2" ];then
	OUTDIR=`dirname $2`
	OUTFILE=`basename $2`
	OUTPUT=$OUTDIR/"signed_"$OUTFILE
	echo "[SIG] [$2] to [$OUTPUT]..."
	rm -f $OUTPUT
	java -jar $SIGNAPK $X509m $PK8m $2 $OUTPUT
else
	echo "[APK] $2 is no exist..."
	exit -1;
fi
