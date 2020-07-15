#!/bin/bash

#gstyle input is dir/*.go

maxWidth=80
maxFileLength=1000
maxFunctionHeight=48

line_num_w_width () {
	idx=0
	max=$(($2+1))
	IFS=''
	while read line;
	do
		trans=$(echo $line | sed 's/\t/~~~~~~~~/') 
		len=$(echo $trans | wc -c)	
		#echo $len $2
		if [ $len -gt $max ]; then
			#echo $len	
			#echo $trans
			line_no=$((idx+1))
			echo $line_no 
		fi
		idx=$((idx+1))
	done < $1
}

#check width
check_width () {
	width=$(wc -L < $1)
	if [ $width -gt $maxWidth ]; then
		#line_num_w_width $1 $maxWidth
		line_nums=$(line_num_w_width $1 $maxWidth)
		for line_num in $line_nums
		do
			echo $1 "line:" $line_num
			echo "styleOffense: width" 
		done
	fi
}
check_width $1

#check length of file
check_len_of_file () {
	fileLength=$(wc -l < $1)
	if [ $fileLength -gt $maxFileLength ]; then
		echo $1
		echo "styleOffense: fileLength" $fileLength 
	fi
}
check_len_of_file $1

# check length of closures 
# TODO

#echo "gs returns"
