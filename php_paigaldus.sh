#!/bin/bash
# Kontrollib, kas php on paigaldatud
# ning vajadusel paigaldab selle

INSTALLSTATUS=$(dpkg-query -W -f='${status}' php 2>/dev/null | grep -c 'ok installed')

if [ $INSTALLSTATUS -eq 0 ];then
        printf 'Paigaldame php\n'
        apt update
	# libapache2-mod-php on juba php dependency, pole vaja eraldi paigaldada
        apt install php php-mysql 
        printf 'Php on paigaldatud!\n'
elif [ $INSTALLSTATUS -eq 1 ];then
        printf 'Php on juba paigaldatud!\n'
	which php
fi
