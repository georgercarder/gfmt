#!/bin/bash

echo "gfmt: running ..."

#goimports
dirs=$(go list -f {{.Dir}} ./...)
for d in $dirs; 
	do goimports -w $d/*.go &
done

#detect and print files w offending style
#echo $dirs
for d in $dirs;
	do gstyle $d/*.go &
done
