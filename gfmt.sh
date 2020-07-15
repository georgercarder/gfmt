#!/bin/bash

echo "gfmt: running ..."
echo ""

gfmt_base_dir=".gfmt/timestamp_n_hash"
lastModDoc=$gfmt_base_dir"/last_mod.txt"

dirs=$(go list -f {{.Dir}} ./...)

check_diff () { # of directories
	lastMod=$(stat -c %Y $lastModDoc)
	#echo "lastMod" $lastMod

	for elt in $1;
	do
		# check time of each dir against lastMod
		gFiles=$(ls $elt | grep "\.go$")
		#echo $gFiles
		for file in $gFiles;
		do
			fullPath=$elt"/"$file
			lm=$(stat -c %Y $fullPath)
			if [ $lm -gt $lastMod ]; then
				echo $elt
				continue
			fi
		done

	done
}

unique () {
	arr=$1
	echo ${arr[@]} | tr ' ' '\n'| sort -u | tr '\n' ' '
}

#check_diff "${dirs[@]}"
dirs=$(check_diff "${dirs[@]}")
dirs=$(unique "${dirs[@]}")

echo "debug before goimports" $dirs
go_imports () {
	for d in $1; 
		do goimports -w $d/*.go &
	done
	wait
}
go_imports "${dirs[@]}"

#detect and print files w offending style
g_style () {
	echo "debug g_style start"
	lastMod=$(stat -c %Y $lastModDoc)
	for d in $1;
	do
		#echo $d
		gFiles=$(ls $d | grep "\.go$")
		for file in $gFiles;
		do
			fullPath=$d"/"$file
			lm=$(stat -c %Y $fullPath)
			#echo $lm
			if [ $lm -gt $lastMod ]; then
				gstyle $fullPath $gfmt_base_dir &
			fi
		done
	done
	echo "debug g_style wait"
	wait
}
g_style "${dirs[@]}"

touch -m $lastModDoc

echo ""
echo "gfmt: done."
