#!/bin/bash

INSTALLSTATUS=$(dpkg-query -W -f='${status}' mysql-server 2>/dev/null | grep -c 'ok installed')

if [ $INSTALLSTATUS -eq 0 ];then
        printf 'Paigaldame mysql\n'
        apt update
	# libapache2-mod-php on juba php dependency, pole vaja eraldi paigaldada
        apt install mysql-server
        printf 'Mysql on paigaldatud!\n'
	echo "[client]" >> $HOME/.my.ncf
	echo "host = localhost" >> $HOME/.my.ncf
	echo "user=root" >> $HOME/.my.ncf
	echo "password = qwerty" >> $HOME/.my.ncf
elif [ $INSTALLSTATUS -eq 1 ];then
        printf 'Mysql on juba paigaldatud!\n'
	mysql
fi
