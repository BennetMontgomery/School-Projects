#################################
#	NOSTRANGE SCRIPT	#
# Script that deletes all files #
#in a directory that have names #
#containing an x before a y - so#
#called "Strange" files		#
# Bennet Montgomery		#
# Student ID 20074049		#
# 2018-09-25			#
#################################
#!/bin/bash
#changing into the specified directory
#removing all files containing an x followed sometime later by a y in directory
#passed 
#echoes to standard error stream if parameter is not a directory
if [[ -d $1 ]]
then
	cd $1
	rm *x*y*
else
	echo "$1 is not a directory" >&2
fi
