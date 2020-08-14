#!/bin/sh

err_not_installed() {
	app=$1
	echo ""
	echo "installation unsuccessful"
	echo "  $app is not available"
	echo "  check your $app installation"
}

link() {
	script=$1
	name=$(echo $script | sed 's/\..*//g')
	if [ "$name" != "gdp" ]; then 
		name="gdp_"$name
	fi
	binPath=/usr/bin/$name
	if [ ! -z "$binPath" ]; then
		rm $binPath 2> /dev/null
	fi
	ln scripts/$script $binPath
}

go get golang.org/x/tools/cmd/goimports
errFlag=$?
if [ ! $errFlag -eq 0 ]; then
	err_not_installed "goimports"
	exit 1
fi

link gfmt.sh
ext=$?
link gstyle.sh
ext=$(($ext||$?))
if [ ! $ext -eq 0 ]; then
	echo ""
	echo "  installation unsuccessful"
	echo "  try:"
	echo "  - using sudo"
	echo "  - removing symlinks /usr/bin/gfmt /usr/bin/gstyle and try again"
	echo ""
	exit 1
fi
echo "installation complete."
echo ""
echo "use: run 'gfmt' from any golang folder."
