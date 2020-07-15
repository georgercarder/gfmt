#!/bin/bash

#gstyle input is dir/*.go

maxWidth=80
maxFileLength=1000
maxFunctionHeight=47

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
	#echo "debug before width"
	width=$(wc -L < $1)
	#echo "debug after width"
	if [ $width -gt $maxWidth ]; then
		#line_num_w_width $1 $maxWidth
		line_nums=$(line_num_w_width $1 $maxWidth)
		for line_num in $line_nums
		do
			echo $1":"$line_num
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

update_t_file () { # touch
	fullFilePath=$1
	simPath=$2$fullFilePath
	file=${simPath##*/}
	path=$(echo $simPath | sed -e "s/$file$//g")
	mkdir -p $path
	touch -m $simPath
}

# check length of closures 
# TODO

check_func_len () {
	fullFilePath=$1
	func="^func"
	rBrac="^}"
	idx=0
	funcIdx=0
	bracIdx=0
	IFS=''
	while read line
	do
		if [ $funcIdx -eq 0 ]; then
			funcFound=$(echo $line | grep $func)
			if [ "$funcFound" != "" ]; then
				#echo $line
				funcIdx=$idx
			fi
		else
			# we look for rBrac
			bracFound=$(echo $line | grep $rBrac)
			if [ "$bracFound" != "" ]; then
				#echo $line	
				bracIdx=$idx
				functionLength=$((bracIdx-funcIdx))
				if [ $functionLength -gt $maxFunctionHeight ];
				then
					echo $fullFilePath":"$funcIdx
					echo "styleOffense: functionHeight" 
					return 1
				fi
				funcIdx=0
				bracIdx=0
			fi
		fi
		idx=$((idx+1))
	done < $fullFilePath	
}

runner() {
	check_width $1
	ret1=$?
	#echo "debug after check_width"
	check_len_of_file $1
	#echo "debug after check_len_of_file"
	ret2=$?
	check_func_len $1
	ret3=$?
	offender=$(($ret1||$ret2||$ret3))
	if [ $offender -eq 0 ]; then
		# not an offender
		update_t_file $1 $2
	fi		
}
runner $1 $2 
