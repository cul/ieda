#!/bin/bash
iedafiles=$(ls /tmp/IEDA-*)
if [ $iedafiles ]; then
	echo "removing prior temp files"
	rm /tmp/IEDA-*
fi
rm copy/original/*
git checkout copy
bin/run.sh original copy $1