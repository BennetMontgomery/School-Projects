#################################################
#		PIG LATIN SCRIPT		#
# Script for assignment 2 that implements the	# 
#pig latin rules described in the assignment	#
#requirements document.				#
# Bennet Montgomery				#
# Student ID 20074049				#
# 2018-10-12					# 
#################################################
#!/bin/bash

#ERROR HANDLING
#catching case where an improper number of arguments are passed
if [ $# -ne 1 ]
then
	>&2 echo "error: wrong number of arguments for pigLatin.sh (needs exactly one)"
fi

#checking for leading vowel (including "y").
#if leading vowel is present, there is no need to continue, just output the
#argument with "way" appended.
if [[ "$1" == "a"* ]] || [[ "$1" == "e"* ]] || [[ "$1" == "i"* ]] || [[ "$1" == "o"* ]] || [[ "$1" == "u"* ]]
then
	echo "${1}way"
	exit
fi

#vowelindex keeps track of the earliest appearance of a vowel in the input
#for slicing together the final output. Defaults to the last character in input
#in case no vowel is present.
VOWELINDEX=${#1}
#iterating through input in reverse, setting the vowelindex to the latest vowel
#present, ensuring the final vowelindex is always the earliest occuring vowel.
for ((i=${#1}-1; i>=0; i--))
do
	LETTER=${1:i:1} 
	if [[ "$LETTER" == "a" ]] || [[ "$LETTER" == "e" ]] || [[ "$LETTER" == "i" ]] || [[ "$LETTER" == "o" ]] || [[ "$LETTER" == "u" ]]
	then
		VOWELINDEX=$i
	fi
done

#slicing front of string off at vowel, and appending it with ay
echo "${1:$VOWELINDEX}${1:0:$VOWELINDEX}ay"
exit
