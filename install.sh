#!/bin/bash

if [[ ! "$INSTALL_PATH" ]];then
	INSTALL_PATH="$HOME/goinfre/bin"
fi

function	make_dir()
{
	echo "Attempting to create $INSTALL_PATH"

	if [ ! mkdir -p "$INSTALL_PATH" ];then
		>&2 echo "Failed to create $INSTALL_PATH, exiting..." && exit 1
	elif [[ ! -r "$INSTALL_PATH" ]] || [[ ! -w "$INSTALL_PATH" ]];then
		>&2 echo "Bad permissions. Exiting..."
		cleanup
	fi
}

function	paste_path()
{
	# Trying to guess whether zsh or something else is being used
	local SHELL_=$([ -n "$1" ] && echo "$HOME/.zshrc" || echo "$HOME/.profile")
	local EXPORT_STR="export PATH=$INSTALL_PATH:\$PATH"

	# Check whether such a line exists in the config file and paste if needed
	if [[ -z $(grep "$EXPORT_STR" "$SHELL_") ]]; then
		echo "$EXPORT_STR" >> "$SHELL_"
	fi
}

function	cleanup()
{
	>&2 echo "Failed to install mkcpp. Try a different directory."

	rm -f "$INSTALL_PATH/mkcpp"
	[[ -f "$HOME/.zshrc" ]] && sed -i '' /"#mkcpp"/d $HOME/.zshrc
	[[ -f "$HOME/.profile" ]] && sed -i '' /"#mkcpp"/d $HOME/.profile
	exit 1
}

function	__main_()
{
	# Make the directory and paste to PATH if needed
	[[ ! -d "$INSTALL_PATH" ]] && make_dir
	paste_path "$(echo -n $SHELL | grep -wo 'zsh')"

	# Attempt to download or move. Clean up if it fails
	echo "Moving cpp_maker to $INSTALL_PATH"
	curl -lso mkcpp https://raw.githubusercontent.com/Shimata/cpp_maker/master/cpp_maker.sh
	[ $? == 0 ] && chmod u+x mkcpp && mv mkcpp "$INSTALL_PATH" || cleanup

	"$INSTALL_PATH/mkcpp" --help > /dev/null && \
	echo "Done! Restart your terminal." && exit 0
	cleanup
}

__main_
