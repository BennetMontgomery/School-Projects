#########################################
#	GRADE DISTRIBUTION SCRIPT	#
# Script for assignment 2 that prints   #
#the distribution of grades to standard #
#output.				#
# Bennet Montgomery			#
# Student ID 20074049			#
# 2018-10-12				#
#########################################
#!/bin/bash				

#ERROR CATCHING
# catching cases where less than 2 arguments are passed:
if [ $# -ne 2 ]
then
	>&2 echo "error: gradeDist.sh needs two arguments"
	exit
fi
# catching cases where a nonexistant or nonexecutable file is passed as the
# grader script
if [ ! -x $1 ]
then
	>&2 echo "error: $1 is not an existing, executable file"
	exit
fi
# catching cases where a nonexistant directory or non-directory file is passed
# as the folder argument
if [ ! -d $2 ]
then
	>&2 echo "error: folder $2 does not exist"
	exit
fi

#instantiating grade counters for each letter grade (default 0)
acount=0
bcount=0
ccount=0
dcount=0
fcount=0

#creating temporary file to store grade stream for later passover
touch result

#iterating through all the files in the passed folder, and echoing the result
#of applying the grader script to the temporary file
for FILE in $2/*
do
	$1 $FILE >> result
done

#iterating through each grade in temporary file and incrementing the
#appropriate grade counter
for GRADE in `cat ./result`
do
	if [ "$GRADE" = "A" ]
	then
		((acount++))
	elif [ "$GRADE" = "B" ]
	then
		((bcount++))
	elif [ "$GRADE" = "C" ]
	then
		((ccount++))		
	elif [ "$GRADE" = "D" ]
	then
		((dcount++))
	else
		((fcount++))
	fi
done

#echoing the distribution results to standard output
echo "A: $acount"
echo "B: $bcount"
echo "C: $ccount"
echo "D: $dcount"
echo "F: $fcount"
#cleaning up temporary file
rm result
