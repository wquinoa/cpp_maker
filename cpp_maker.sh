#!/bin/bash

#_
#_    -h --help      : Description/manual
#_    -u --uninstall : Uninstall mkcpp
#_
#_Description:
#_    Creates Coplien form cpp + hpp class dummies with the filename(s)
#_    passed as args in the current directory.
#_    If one of the arguments is "main", it will create a main.cpp
#_    with all the other arguments as #includes.
#_    If the specified files exist, prefixes the new files with "cp_"
#_    to prevent overwriting the old ones.
#_

set -o pipefail
set -o errtrace
set -o errexit

trap ">&2 echo mkcpp: fatal error; exit 1" 2 3 9 15

header()
{
	printf "/* ************************************************************************** */\n" >> "$file"
	printf "/*                                                                            */\n" >> "$file"
	printf "/*                                                        :::      ::::::::   */\n" >> "$file"
	printf "/*   %-51s:+:      :+:    :+:   */\n" "$file" >> "$file"
	printf "/*                                                    +:+ +:+         +:+     */\n" >> "$file"
	printf "/*   By: %-43s+#+  +:+       +#+        */\n" "$USER <$USER@student.21-school.ru>" >> "$file"
	printf "/*                                                +#+#+#+#+#+   +#+           */\n" >> "$file"
	printf "/*   Created: %-41s#+#    #+#             */\n" "$(date +"%Y/%m/%d") $(date +%T) by $USER" >> "$file"
	printf "/*   Updated: %-40s###   ########.fr       */\n" "$(date +"%Y/%m/%d") $(date +%T) by $USER" >> "$file"
	printf "/*                                                                            */\n" >> "$file"
	printf "/* ************************************************************************** */\n\n" >> "$file"
}

createCPP()
{
	file="$path.cpp"
	name="${name##*\/}"
	[[ -f "$file" ]] && >&2 printf "mkcpp: $file exists. Creating cp_$file\n" && file="cp_$file"

	header
	printf "#include \"%s.hpp\"\n\n" "$name" >> "$file"
	printf "%s::%s()\n{\n}\n\n" "$name" "$name" >> "$file"
	printf "%s::~%s()\n{\n}\n\n" "$name" "$name" >> "$file"

	printf "%s::%s(const %s &copy)\n{\n" "$name" "$name" "$name" >> "$file"
	printf "}\n\n" >> "$file"
	printf "%s	&%s::operator=(const %s &copy)\n{\n" "$name" "$name" "$name" >> "$file"
	printf "	return (*this);\n" >> "$file"
	printf "}\n" >> "$file"
}

createHPP()
{
	file="$path.hpp"
	name="${name##*\/}"
	name_upper="$(echo $name | tr '[:lower:]' '[:upper:]')"
	[[ -f "$file" ]] && >&2 printf "mkcpp: $file exists. Creating cp_$file\n" && file="cp_$file"

	header
	printf "#ifndef %s_HPP\n" "$name_upper" >> "$file"
	printf "# define %s_HPP\n" "$name_upper" >> "$file"
	printf "# include <iostream>\n\n" >> "$file"

	printf "class %s\n{\n" "$name" >> "$file"
	printf "public:\n" >> "$file"
	printf "	%s();\n" "$name" >> "$file"
	printf "	%s(const %s &copy);\n" "$name" "$name" >> "$file"
	printf "	~%s();\n" "$name" >> "$file"
	printf "	%s &operator=(const %s &copy);\n" "$name" "$name" >> "$file"

	printf "\nprivate:\n" >> "$file"
	printf "};\n\n" >> "$file"
	printf "#endif\n" >> "$file"
}

mkmain()
{
	file="$path.cpp"
	[[ -f "$file" ]] && >&2 printf "mkcpp: $file exists. Creating cp_$file\n" && file="cp_$file"

	header
	for class in "${@/.[c|h]pp/}"; do
		class="${class/,/}"
		if [[ ${class##*\/} != main ]]; then
			printf "#include \"$class.hpp\"\n" >> "$file"
		fi
	done
	printf "\nint		main(void)\n" >> "$file"
	printf "{\n	return (0);\n}\n" >> "$file"
}

init()
{
	readonly args=${@/.[c|h]pp/}
	for arg in $args; do
		name="${arg/,/}"
		path="$name"
		if [[ ${arg##*\/} != main ]]; then
			createCPP
			createHPP
		else
			mkmain $@
		fi
	done
}

uninstall()
{
	readonly install_path="$( cd "$(dirname $0)" >/dev/null 2>&1 ; pwd -P )"

	[[ -f "$HOME/.zshrc" ]] && sed -i '' "/#mkcpp/d" "$HOME/.zshrc"
	[[ -f "$HOME/.profile" ]] && sed -i '' "/#mkcpp/d" "$HOME/.profile"
	printf "Removed $install_path from PATH.\n"
	printf "Bye! Please star the repo if it was useful :)\nhttps://github.com/wquinoa/cpp_maker\n"
	rm -f "$install_path/mkcpp"
}

__main_()
{
	readonly USAGE="\n\033[1m    usage: mkcpp [-hu] file ...\033[0m\n"

	case "$1" in
		'-u' | '--uninstall')	uninstall ;;
		'-h' | '--help' )		printf "$USAGE" && grep '^#_' "$0" | cut -c3- ;;
		'' ) 					printf "$USAGE" && grep -m4 '^#_' "$0" | cut -c3- ;;
		* ) init $@ ;;
	esac
	exit 0
}

__main_ $@
