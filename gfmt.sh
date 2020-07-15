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
		for file in $gFiles;
		do
			fullPath=$d"/"$file
			gstyle $fullPath $gfmt_base_dir &
		done
	done
	wait
}
g_style "${dirs[@]}"

mkdir $gfmt_base_dir
lastTouch=$gfmt_base_dir"/last_touch.txt"
touch $lastTouch

echo "gfmt: done."
