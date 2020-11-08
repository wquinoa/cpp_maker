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
	# Not trying to guess whether zsh or something else is being used sorry
	local export_str="export PATH=$install_path:\$PATH #mkcpp"

	[[ -f "$HOME/.zshrc" ]] && printf "$export_str\n" >> $HOME/.zshrc
	[[ -f "$HOME/.profile" ]] && printf "$export_str\n" >> $HOME/.profile
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
	make_dir
	paste_path 

	# Attempt to download or move. Clean up if it fails
	printf "Moving cpp_maker to $install_path\n"
	curl -lso mkcpp https://raw.githubusercontent.com/wquinoa/cpp_maker/master/cpp_maker.sh
	[ $? == 0 ] && chmod u+x mkcpp && mv mkcpp "$install_path" || cleanup

	"$install_path/mkcpp" --help > /dev/null && \
	printf "Done! Restart your terminal.\n" && exit 0
	cleanup
}

__main_
