#!/bin/bash

echo "gfmt: running ..."

gfmt_base_dir=".gfmt/timestamp_n_hash"

dirs=$(go list -f {{.Dir}} ./...)

check_diff () {
	for elt in $1;
	do
		#fpath=$gfmt_base_dir$elt
		# check time

		# check hash
		#echo "hello"
		echo $elt
	done
}
#dirs=$(check_diff "${dirs[@]}")

#goimports
#echo "before goimports" $dirs
go_imports () {
	for d in $1; 
		do goimports -w $d/*.go &
	done
	wait
}
go_imports "${dirs[@]}"


#detect and print files w offending style
g_style () {
	for d in $1;
	do
		#echo $d
		gFiles=$(ls $d | grep "\.go$")
		#echo ${gFiles[@]}
		for file in $gFiles;
		do
			fullPath=$d"/"$file
			#echo $fullPath
			gstyle $fullPath
		done
		#do gstyle $d/*.go &
	done
	#wait
}
g_style "${dirs[@]}"

update_tnh_file () {
	fullFilePath=$1"/"$2
	if [[ -f $fullFilePath ]]; then
		#echo $fullFilePath
		h=($(sha256sum $fullFilePath))
		hhashPath=$3"/"$2
		echo ${h[0]} > $hhashPath
	fi
}

update_timestamp_n_hash () {
	for elt in $1;
	do
		hashPath=$gfmt_base_dir$elt
		mkdir -p $hashPath
		files=$(ls $elt)
		for f in $files;
		do
			update_tnh_file $elt $f $hashPath &
		done
	done
	wait
	lastTouch=$gfmt_base_dir"/last_touch.txt"
	touch $lastTouch
}
update_timestamp_n_hash "${dirs[@]}"

echo "gfmt: done."
