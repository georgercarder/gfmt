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
			return 1
		done
	fi
}

#check length of file
check_len_of_file () {
	fileLength=$(wc -l < $1)
	if [ $fileLength -gt $maxFileLength ]; then
		echo $1
		echo "styleOffense: fileLength" $fileLength 
		return 1
	fi
}

# check length of closures 
# TODO

#echo "gs returns"

update_tnh_file () {
	fullFilePath=$1
	h=($(sha256sum $fullFilePath))
	hhashPath=$2$fullFilePath
	file=${hhashPath##*/}
	path=$(echo $hhashPath | sed -e "s/$file$//g")
	mkdir -p $path
	echo $h > $hhashPath
}

runner() {
	check_width $1
	ret1=$?
	check_len_of_file $1
	ret2=$?
	offender=$ret1||$ret2
	#echo "offender" $offender
	if [ $offender -eq 0 ]; then
		# not an offender
		update_tnh_file $1 $2
	fi		
}
runner $1 $2 
