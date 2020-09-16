#!/bin/bash

function	header()
{
	printf "/* ************************************************************************** */\n" >> $FILE
	printf "/*                                                                            */\n" >> $FILE
	printf "/*                                                        :::      ::::::::   */\n" >> $FILE
	printf "/*   %-51s:+:      :+:    :+:   */\n" $FILE >> $FILE
	printf "/*                                                    +:+ +:+         +:+     */\n" >> $FILE
	printf "/*   By: %-43s+#+  +:+       +#+        */\n" "$USER <$USER@student.21-school.ru>" >> $FILE
	printf "/*                                                +#+#+#+#+#+   +#+           */\n" >> $FILE
	printf "/*   Created: %-41s#+#    #+#             */\n" "$(date +"%Y/%m/%d") $(date +%T) by $USER" >> $FILE
	printf "/*   Updated: %-40s###   ########.fr       */\n" "$(date +"%Y/%m/%d") $(date +%T) by $USER" >> $FILE
	printf "/*                                                                            */\n" >> $FILE
	printf "/* ************************************************************************** */\n\n" >> $FILE
}

INSTALL_PATH="/Users/wquinoa/goinfre/bin/"

function	createCPP()
{
	FILE="$NAME.cpp"
	rm -rf $FILE

	header
	printf "#include \"%s.hpp\"\n\n" $NAME >> $FILE
	printf "%s::%s()\n{\n}\n\n" $NAME $NAME >> $FILE
	printf "%s::~%s()\n{\n}\n" $NAME $NAME >> $FILE

	printf "\n" >> $FILE
	printf "%s::%s(const %s &copy)\n{\n" $NAME $NAME $NAME >> $FILE
	printf "	*this = copy;\n" >> $FILE
	printf "}\n\n" >> $FILE
	printf "%s	&%s::operator=(const %s &copy)\n{\n" $NAME $NAME $NAME >> $FILE
	printf "	return (*this);\n" >> $FILE
	printf "}\n" >> $FILE
}

function	createHPP()
{
	FILE="$NAME.hpp"
	rm -rf $FILE

	header
	printf "#ifndef %s_HPP\n" $NAME_UPPER >> $FILE
	printf "# define %s_HPP\n" $NAME_UPPER >> $FILE
	printf "# include <iostream>\n\n" >> $FILE

	printf "class %s\n{\n" $NAME >> $FILE
	printf "public:\n" >> $FILE
	printf "	%s();\n" $NAME >> $FILE
	printf "	%s(const %s &copy);\n" $NAME $NAME >> $FILE
	printf "	~%s();\n" $NAME >> $FILE
	printf "	%s &operator=(const %s &copy);\n" $NAME $NAME >> $FILE

	printf "\nprivate:\n" >> $FILE
	printf "};\n\n" >> $FILE
	printf "#endif\n" >> $FILE
}

function	mkmain()
{
	FILE="main.cpp"
	rm -rf $FILE

	header
	for class in "$@"; do
		if [ $class != main ]; then
			printf "#include \"$class.hpp\"\n" >> $FILE
		fi
	done
	printf "\nint		main(void)\n" >> $FILE
	printf "{\n	return (0);\n}\n" >> $FILE
}

function	init()
{
	for arg in "$@"; do
		NAME=$(echo $arg | sed 's/\.[c|h]pp//g')
		NAME_UPPER=$(echo $NAME | tr '[:lower:]' '[:upper:]')
		if [ $arg != main ]; then
			createCPP
			createHPP
		else
			mkmain $@
		fi
	done
	exit
}

if [ -z $1 ] || [ $1 == --help ] || [ $1 == -h ]; then
	printf "\n    Creates cpp + hpp class dummies with the filename(s) passed as args\n"
	printf "\n    usage: \033[1mmkcpp\033[0m <filename1> <filename2> ...\n";
	printf "\n    -h --help : Invoke this manual\n    --uninstall : Uninstall mkcpp\n\n"
elif [ $1 == --uninstall ];then
	if [ -f $HOME/.zshrc ];then
		sed -i '' /"#mkcpp"/d $HOME/.zshrc > /dev/null
	elif [ -f $HOME/.profile ];then
		sed -i '' /"#mkcpp"/d $HOME/.profile > /dev/null 
	fi
	echo "Goodbye!"
	rm -f $INSTALL_PATH/mkcpp
else
	init $@
fi
