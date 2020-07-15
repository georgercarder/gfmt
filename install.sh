#!/bin/bash

go get golang.org/x/tools/cmd/goimports

ln scripts/gfmt.sh /usr/bin/gfmt
ln scripts/gstyle.sh /usr/bin/gstyle

echo "installation complete."
echo ""
echo "use: run 'gfmt' from any golang folder."
