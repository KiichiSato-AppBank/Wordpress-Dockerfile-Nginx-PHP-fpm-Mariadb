#!/bin/sh
systemctl start mariadb
systemctl enable mariadb

echo -n INPUT DATABASE NAME:
read DB_NAME
DB_PASS=`pwgen -c -n -1 12`
echo your current mysql password is empty
echo
echo '############################################'
echo this is your new mysql password $DB_PASS
echo '############################################'
echo
echo enter this new password in the next step
echo if you forget the password, enter 'echo $DB_PASS'
mysql_secure_installation
mysql -u root -p$DB_PASS -e "create database $DB_NAME;"
mysql -u root -p$DB_PASS -e "grant all privileges on wordpress1.* to root@localhost identified by '$DB_PASS';"
mysql -u root -p$DB_PASS -e "flush privileges;"

#sed
sed -i -e "s/database_name_here/$DB_NAME/
  s/username_here/root/
  s/password_here/$DB_PASS/
  /'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /usr/share/nginx/html/wordpress/wp-config.php

sed -i -e '82c define( '\''WP_DEBUG'\'', true );' /usr/share/nginx/html/wordpress/wp-config.php
sed -i -e '92c define( '\''ABSPATH'\'',wordpress. '\''/usr/share/nginx/html/wordpress'\'' );' /usr/share/nginx/html/wordpress/wp-config.php

chown -R nginx:nginx /usr/share/nginx/html/wordpress/wp-config.php

sed -i -e '3c server_name '$DB_NAME'.net;' /etc/nginx/conf.d/wordpress.conf

systemctl start nginx
systemctl enable nginx
systemctl start php-fpm
systemctl enable php-fpm
systemctl restart mariadb
echo visit this URL for checking whether your nginx is working
echo localhost:
echo visit this URL for your new wordpress on the localhost
echo localhost:/wp-admin/install.php
