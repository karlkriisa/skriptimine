#!/bin/bash
# Kontrollib, kas phpmyadmin on paigaldatud
# ning vajadusel paigaldab selle

INSTALLSTATUS=$(dpkg-query -W -f='${status}' phpmyadmin 2>/dev/null | grep -c 'ok installed')

if [ $INSTALLSTATUS -eq 0 ];then
        printf 'Paigaldame phpmyadmin\n'
        apt update
        apt install phpmyadmin
        printf 'Phpmyadmin on paigaldatud!\n'
elif [ $INSTALLSTATUS -eq 1 ];then
        printf 'Phpmyadmin on juba paigaldatud!\n'
fi
