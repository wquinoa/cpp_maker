#!/bin/bash

if [ ! $INSTALL_PATH ];then
	INSTALL_PATH="$HOME/goinfre/bin/"
fi

function	make_dir()
{
	echo "Attempting to create $INSTALL_PATH"
	mkdir -p $INSTALL_PATH
	if [ $? != 0 ];then
		echo "Failed to create $INSTALL_PATH, exiting..."
		exit 1
	fi
}

function	paste_env()
{
	local SHELL_=$(echo -n $SHELL | grep -wo 'zsh')
	if [ $SHELL_ == zsh ];then
		if [ -z "$( grep "export PATH=$INSTALL_PATH:\$PATH" < ~/.zshrc)" ]; then
			echo "export PATH=$INSTALL_PATH:\$PATH" >> ~/.zshrc
		fi
	else
		if [ -z "$( grep "export PATH=$INSTALL_PATH:\$PATH" < ~/.profile)" ]; then
			echo "export PATH=$INSTALL_PATH:\$PATH	#mkcpp" >> ~/.zshrc
		fi
	fi
}

if [ ! -d $INSTALL_PATH ];then
	make_dir
fi
paste_env
if [ ! -r $INSTALL_PATH ] || [ ! -w $INSTALL_PATH ];then
	echo "Bad permissions, try a different directory"
	exit 1
fi

echo "Moving cpp_maker to $INSTALL_PATH"

curl -lso mkcpp https://raw.githubusercontent.com/Shimata/cpp_maker/master/cpp_maker.sh
sed -i '' s+__PATH__+$INSTALL_PATH+ $PWD/mkcpp
chmod u+x mkcpp
mv mkcpp $INSTALL_PATH
$INSTALL_PATH/mkcpp --help
echo "Done! Restart your terminal before use."
