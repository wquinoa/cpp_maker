#!/bin/bash

$INSTALL_PATH="/usr/local/bin/"

echo "Moving cpp_maker to $INSTALL_PATH"
curl -lso cpp_maker https://raw.githubusercontent.com/wquinoa/cpp_maker/master/cpp_maker
chmod u+x cpp_maker
mv cpp_maker $INSTALL_PATH
echo "Done!"
printf "%-7susage: \033[1mcpp_maker\033[0m <filename1> <filename2> ...\n\n" " ";
