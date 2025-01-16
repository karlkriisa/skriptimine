#!/bin/bash

# Kontrollib, kas Apache2 on masinal
# paigaldatud ning vajadusel paigaldab

INSTALLSTATUS=$(dpkg-query -W -f='${status}' apache2 2>/dev/null | grep -c 'ok installed')

if [ $INSTALLSTATUS -eq 0 ];then
	printf 'Paigaldame Apache2\n'
	apt update
	apt install apache2
	printf 'Apache2 on paigaldatud!\n'
elif [ $INSTALLSTATUS -eq 1 ];then
	printf 'Apache2 on juba paigaldatud!\n'
	systemctl start apache2
	systemctl status apache2
fi
