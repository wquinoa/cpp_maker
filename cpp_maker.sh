#!/bin/bash

cleanup()
{
	>&2 printf "mkcpp: failed to write to $1. Deleting $1...\n"
	rm -f "$NAME.cpp" "$NAME.hpp"
	exit 1
}

header()
{
	printf "/* ************************************************************************** */\n" >> ""$FILE"" || cleanup "$FILE"
	printf "/*                                                                            */\n" >> "$FILE"
	printf "/*                                                        :::      ::::::::   */\n" >> "$FILE"
	printf "/*   %-51s:+:      :+:    :+:   */\n" "$FILE" >> "$FILE"
	printf "/*                                                    +:+ +:+         +:+     */\n" >> "$FILE"
	printf "/*   By: %-43s+#+  +:+       +#+        */\n" "$USER <$USER@student.21-school.ru>" >> "$FILE"
	printf "/*                                                +#+#+#+#+#+   +#+           */\n" >> "$FILE"
	printf "/*   Created: %-41s#+#    #+#             */\n" "$(date +"%Y/%m/%d") $(date +%T) by $USER" >> "$FILE"
	printf "/*   Updated: %-40s###   ########.fr       */\n" "$(date +"%Y/%m/%d") $(date +%T) by $USER" >> "$FILE"
	printf "/*                                                                            */\n" >> "$FILE"
	printf "/* ************************************************************************** */\n\n" >> "$FILE"
}

createCPP()
{
	local FILE="$NAME.cpp"
	[ -f "$FILE" ] && >&2 printf "mkcpp: $FILE exists. Creating cp_$FILE\n" && FILE="cp_$FILE"

	header
	printf "#include \"%s.hpp\"\n\n" "$NAME" >> "$FILE"
	printf "%s::%s()\n{\n}\n\n" "$NAME" "$NAME" >> "$FILE"
	printf "%s::~%s()\n{\n}\n\n" "$NAME" "$NAME" >> "$FILE"

	printf "%s::%s(const %s &copy)\n{\n" "$NAME" "$NAME" "$NAME" >> "$FILE"
	printf "}\n\n" >> "$FILE"
	printf "%s	&%s::operator=(const %s &copy)\n{\n" "$NAME" "$NAME" "$NAME" >> "$FILE"
	printf "	return (*this);\n" >> "$FILE"
	printf "}\n" >> "$FILE"
}

createHPP()
{
	local FILE="$NAME.hpp"
	[ -f "$FILE" ] && >&2 printf "mkcpp: $FILE exists. Creating cp_$FILE\n" && FILE="cp_$FILE"

	header
	printf "#ifndef %s_HPP\n" "$NAME_UPPER" >> "$FILE"
	printf "# define %s_HPP\n" "$NAME_UPPER" >> "$FILE"
	printf "# include <iostream>\n\n" >> "$FILE"

	printf "class %s\n{\n" "$NAME" >> "$FILE"
	printf "public:\n" >> "$FILE"
	printf "	%s();\n" "$NAME" >> "$FILE"
	printf "	%s(const %s &copy);\n" "$NAME" "$NAME" >> "$FILE"
	printf "	~%s();\n" "$NAME" >> "$FILE"
	printf "	%s &operator=(const %s &copy);\n" "$NAME" "$NAME" >> "$FILE"

	printf "\nprivate:\n" >> "$FILE"
	printf "};\n\n" >> "$FILE"
	printf "#endif\n" >> "$FILE"
}

mkmain()
{
	local FILE="main.cpp"
	[ -f "$FILE" ] && >&2 printf "mkcpp: $FILE exists. Creating cp_$FILE\n" && FILE="cp_$FILE"

	header
	for class in "$@"; do
		if [ $class != main ]; then
			printf "#include \"$class.hpp\"\n" >> "$FILE" 
		fi
	done
	printf "\nint		main(void)\n" >> "$FILE"
	printf "{\n	return (0);\n}\n" >> "$FILE"
}

init()
{
	for arg in "$@"; do
		NAME="$(echo $arg | sed 's/\.[c|h]pp//g')"
		NAME_UPPER="$(echo $NAME | tr '[:lower:]' '[:upper:]')"
		if [ $arg != main ]; then
			createCPP
			createHPP
		else
			mkmain $@
		fi
	done
}

uninstall()
{
	local INSTALL_PATH="$( cd "$(dirname $0)" >/dev/null 2>&1 ; pwd -P )"

	[ -f "$HOME/.zshrc" ] && sed -i '' "/#mkcpp/d" "$HOME/.zshrc"
	[ -f "$HOME/.profile" ] && sed -i '' "/#mkcpp/d" "$HOME/.profile"
	printf "Removed $INSTALL_PATH from PATH.\n"
	printf "Deleting mkcpp. Goodbye!\n"
	rm -f "$INSTALL_PATH/mkcpp"
}

#_
#_    -h --help      : Invoke manual
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

__main_()
{
	local USAGE="\n${BOLD}    usage: mkcpp [-hu] file ...${RE}\n"

	case "$1" in
		'-u' | '--uninstall')	uninstall ;;
		'-h' | '--help' )		printf "$USAGE" && grep '^#_' "$0" | cut -c3- ;;
		'' ) 					printf "$USAGE" && grep -m4 '^#_' "$0" | cut -c3- ;;
		* ) init $@ ;;
	esac
	exit 0
}

__main_ $@
