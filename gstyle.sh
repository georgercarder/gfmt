#!/bin/bash

#gstyle input is dir/*.go

maxWidth=80
maxFileLength=1000
maxFunctionHeight=48

#check width
check_width () {
	width=$(wc -L < $1)
	if [ $width -gt $maxWidth ]; then
		echo "styleOffense: width " $1 $width
	fi
}
check_width $1


#check length of file
check_len_of_file () {
	fileLength=$(wc -l < $1)
	if [ $fileLength -gt $maxFileLength ]; then
		echo "styleOffense: fileLength " $1 $fileLength
	fi
}
check_len_of_file $1

# check length of closures 
# TODO
