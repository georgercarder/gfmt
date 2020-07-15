#!/bin/bash

go get golang.org/x/tools/cmd/goimports
errFlag=$?
ln scripts/gfmt.sh /usr/bin/gfmt
errFlag=$(($errFlag||$?))
ln scripts/gstyle.sh /usr/bin/gstyle
errFlag=$(($errFlag||$?))
if [ ! $errFlag -eq 0 ]; then
	echo ""
	echo "installation unsuccessful."
	echo "try:"
	echo "  - using sudo"
	echo "  - removing symlinks /usr/bin/gfmt /usr/bin/gstyle and try again"
	echo "  - check go version go1.14.4 linux/amd64 is installed"
	echo "  - system has bash"
	echo ""
	exit 1
fi
echo "installation complete."
echo ""
echo "use: run 'gfmt' from any golang folder."
