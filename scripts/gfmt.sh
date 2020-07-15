#!/bin/bash

echo "gfmt: running ..."
echo ""

gfmt_base_dir=".gfmt/timestamp_n_hash"
lastModDoc=$gfmt_base_dir"/last_mod.txt"

dirs=$(go list -f {{.Dir}} ./...)

check_diff () { # of directories
	if [ ! -f $lastModDoc ]; then
		dirs=$1
		echo ${dirs[@]}
		exit 0 
	fi
	lastMod=$(stat -c %Y $lastModDoc)
	for elt in $1;
	do
		gFiles=$(ls $elt | grep "\.go$")
		#echo $gFiles
		for file in $gFiles;
		do
			fullPath=$elt"/"$file
			# check time of each file against lastMod
			lm=$(stat -c %Y $fullPath)
			if [ $lm -gt $lastMod ]; then
				echo $elt
				continue
			fi
			# check if file does not appear in gfmt_base_dir
			simPath=$gfmt_base_dir$fullPath
			if [ ! -f $simPath ]; then
				echo $elt
			fi
		done

	done
}

unique () {
	arr=$1
	echo ${arr[@]} | tr ' ' '\n'| sort -u | tr '\n' ' '
}

dirs=$(check_diff "${dirs[@]}")
dirs=$(unique "${dirs[@]}")

go_imports () {
	for d in $1; 
		do goimports -w $d/*.go &
	done
	wait
}
go_imports "${dirs[@]}"

#detect and print files w offending style
g_style () {
	lastMod=0
	if [ -f $lastModDoc ]; then
		lastMod=$(stat -c %Y $lastModDoc)
	fi
	for d in $1;
	do
		#echo $d
		gFiles=$(ls $d | grep "\.go$")
		for file in $gFiles;
		do
			fullPath=$d"/"$file
			# check time of each file against lastMod
			lm=$(stat -c %Y $fullPath)
			if [ $lm -gt $lastMod ]; then
				gstyle $fullPath $gfmt_base_dir &
				continue
			fi
			# check if file does not appear in gfmt_base_dir
			simPath=$gfmt_base_dir$fullPath
			if [ ! -f $simPath ]; then
				gstyle $fullPath $gfmt_base_dir &
			fi
		done
	done
	wait
}
g_style "${dirs[@]}"

mkdir -p $gfmt_base_dir
touch -m $lastModDoc

echo ""
echo "gfmt: done."
