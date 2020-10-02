#!/bin/bash

if [[ ! "$install_path" ]];then
	install_path="$HOME/bin"
fi

make_dir()
{
	if ! mkdir -p "$install_path" ;then
		>&2 printf "mkcpp: failed to create $install_path, exiting...\n" && exit 1
	elif [[ ! -r "$install_path" ]] || [[ ! -w "$install_path" ]] ;then
		>&2 printf "mkcpp: bad permissionsfor path. Exiting...\n"
		cleanup
	fi
}

paste_path()
{
	# Trying to guess whether zsh or something else is being used
	local shell_=$([ -n "$1" ] && printf "$HOME/.zshrc" || echo "$HOME/.profile")
	local export_str="export PATH=$install_path:\$PATH #mkcpp"

	# Check whether such a line exists in the config file and paste if needed
	if [[ -z $(grep "$export_str" "$shell_") ]]; then
		printf "$export_str\n" >> "$shell_"
	fi
}

cleanup()
{
	>&2 printf "mkcpp: failed to install mkcpp. Try a different directory.\n"

	rm -f "$install_path/mkcpp"
	[[ -f "$HOME/.zshrc" ]] && sed -i '' /"#mkcpp"/d $HOME/.zshrc
	[[ -f "$HOME/.profile" ]] && sed -i '' /"#mkcpp"/d $HOME/.profile
	exit 1
}

__main_()
{
	# Make the directory and paste to PATH if needed
	[[ ! -d "$install_path" ]] && make_dir
	paste_path "$(printf $SHELL | grep -wo 'zsh')"

	# Attempt to download or move. Clean up if it fails
	printf "Moving cpp_maker to $install_path\n"
	curl -lso mkcpp https://raw.githubusercontent.com/Shimata/cpp_maker/master/cpp_maker.sh
	[ $? == 0 ] && chmod u+x mkcpp && mv mkcpp "$install_path" || cleanup

	"$install_path/mkcpp" --help > /dev/null && \
	printf "Done! Restart your terminal.\n" && exit 0
	cleanup
}

__main_
