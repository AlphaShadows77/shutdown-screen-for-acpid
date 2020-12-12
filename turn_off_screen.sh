#!/bin/bash
tty=$(fgconsole)
if [[ $? != 0 ]]; then
	exit 1;
fi

line=$(ps a -o tty,comm | grep tty$tty | head -1 | sed 's/ \+/ /')
index_command=$(($(expr index "$line" " ") + 1))
command_name=$(expr substr "$line" $index_command $(expr length "$line"))

case $command_name in

	Xorg) 
		user_line=$(who | grep tty$tty | sed 's/ \+/ /')
		length_user=$(($(expr index "$user_line" " ") - 1))
		user=$(expr substr "$user_line" 1 $length_user)

		if [[ $user == "root" ]]; then
			home=/root
		else
			home=/home/$user
		fi

		XAUTHORITY=$home/.Xauthority DISPLAY=:0 xset dpms force off
		;;

	bash)
		openvt -ws -- bash -c "TERM=linux clear && TERM=linux setterm --blank=force && read -n 1 && TERM=linux setterm --blank=poke"
		;;

esac
