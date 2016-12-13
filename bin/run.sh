#!/bin/bash
MD5=`whereis md5sum | cut -f 2 -d ' '`
if [ -z $MD5 ]; then
	echo "cannot find md5sum, trying md5"
	MD5="md5 -r"
fi
DATE=`date "+%Y%m%d"`
TMPNAME="IEDA-$DATE"
SOURCE=$1
TARGET=$2
ADDRESSES=$3
CURDIR=`pwd`
# generate the rsync log
rsync -a -i -n $SOURCE $TARGET | grep "^>f" > /tmp/$TMPNAME.txt
# email the rsync log if there were changes
if [ -s /tmp/$TMPNAME.txt ]; then
	if [ -z $ADDRESSES ]; then
		cat /tmp/$TMPNAME.txt
	else
		cat /tmp/$TMPNAME.txt | mail -s "IEDA transfer changes $DATE" $ADDRESSES
	fi
	rsync -a -i $SOURCE $TARGET
	# generate the md5 sums of the sync'd files
	cd $TARGET
	$MD5 `cat /tmp/$TMPNAME.txt | grep "^>f" | cut -f 2 -d ' '` > /tmp/$TMPNAME.md5
	# email the md5 sums
	cd $CURDIR
	if [ -z $ADDRESSES ]; then
		cat /tmp/$TMPNAME.md5
	else
		cat /tmp/$TMPNAME.md5 | mail -s "IEDA transfer checksums $DATE" $ADDRESSES
	fi
	rm /tmp/$TMPNAME.txt
	rm /tmp/$TMPNAME.md5	
fi