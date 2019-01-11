#################################
#	ADJUSTED LS SCRIPT	#
# Outputs results similar to the#
#ls command with the -l flag but#
#omits owner name, lists files  #
#in order of increasing size, & #
#places quotes around each file #
#name.				#
# Bennet Montgomery		#
# Student ID 20074049		#
# 2018-09-25			#
#################################
#!/bin/bash
#using ls with flags:
#	1. -l: list in long format
#	2. -S: sort by file size (descending)
#	3. -r: reverse sort method (now ascending file size)
#	4. -Q: print file names with quotation marks
#	5. -g: omit author name 
ls -lSrQg $1
