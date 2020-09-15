#!/bin/bash

INSTALL_PATH="/usr/local/bin"

echo "Moving cpp_maker to $INSTALL_PATH"
curl -lso mkcpp https://raw.githubusercontent.com/Shimata/cpp_maker/master/cpp_maker.sh
chmod u+x mkcpp
mv mkcpp $INSTALL_PATH
echo "Done!"
mkcpp --help