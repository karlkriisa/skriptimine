#!/bin/bash

YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2)

printf "${YELLOW}Paigaldame vajalikud paketid...\n"
apt update

INSTALLSTATUS=$(dpkg-query -W -f='${status}' apache2 2>/dev/null | grep -c 'ok installed')

if [ $INSTALLSTATUS -eq 0 ];then
	printf "${YELLOW}Paigaldame Apache2\n"
	apt install apache2
	printf "${GREEN}Apache2 on paigaldatud!\n"
elif [ $INSTALLSTATUS -eq 1 ];then
	printf "${GREEN}Apache2 on juba paigaldatud\n"
	systemctl start apache2
fi

INSTALLSTATUS=$(dpkg-query -W -f='${status}' mysql-server 2>/dev/null | grep -c 'ok installed')

if [ $INSTALLSTATUS -eq 0 ];then
        printf "${YELLOW}Paigaldame mysql\n"
	# libapache2-mod-php on juba php dependency, pole vaja eraldi paigaldada
        apt install mysql-server
        printf "${GREEN}Mysql on paigaldatud!\n"
	echo "[client]" >> $HOME/.my.ncf
	echo "host = localhost" >> $HOME/.my.ncf
	echo "user=root" >> $HOME/.my.ncf
	echo "password = qwerty" >> $HOME/.my.ncf
elif [ $INSTALLSTATUS -eq 1 ];then
        printf "${GREEN}Mysql on juba paigaldatud\n"
fi

INSTALLSTATUS=$(dpkg-query -W -f='${status}' php 2>/dev/null | grep -c 'ok installed')

if [ $INSTALLSTATUS -eq 0 ];then
        printf "${YELLOW}Paigaldame php\n"
	# libapache2-mod-php on juba php dependency, pole vaja eraldi paigaldada
        apt install php php-mysql 
        printf "${GREEN}Php on paigaldatud!\n"
elif [ $INSTALLSTATUS -eq 1 ];then
        printf "${GREEN}Php on juba paigaldatud${NORMAL}\n"
fi

# Laeb alla ja pakib arhiivi lahti /var/www/html kausta
printf "${YELLOW}Paigaldame Wordpressi${NORMAL}\n"
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz -C /var/www/html/
rm ./latest.tar.gz

# Failiõiguste muutmine turvalisuse jaoks
chown -R www-data:www-data /var/www/html/wordpress/
find /var/www/html/wordpress -type d -exec chmod 755 {} \;
find /var/www/html/wordpress -type f -exec chmod 644 {} \;
printf "${GREEN}Wordpress on edukalt paigaldatud!${NORMAL}\n"

# MySQL ülesseadmine
printf "${YELLOW}Teeme MySQL databaasi${NORMAL}\n"
mysql --user="root" --password="qwerty" --execute="CREATE DATABASE wpdatabase;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'qwerty';
GRANT ALL PRIVILEGES ON wpdatabase.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;"
printf "${GREEN}MySQL databaas edukalt tehtud!${NORMAL}\n"


# wp-config.php faili ümbernimetamine ja
# asendamine korrektse databaasi infoga
mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/wpdatabase/g" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/wpuser/g" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/qwerty/g" /var/www/html/wordpress/wp-config.php
