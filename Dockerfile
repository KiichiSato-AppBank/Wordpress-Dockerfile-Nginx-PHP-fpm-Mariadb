FROM centos:8

### "Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist" centos8
# https://www.na3.jp/entry/20220213/p1 
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*

RUN yum -y update

RUN su
###

### nginx install
# http://nginx.org/en/linux_packages.html#RHEL-CentOS

RUN yum install -y yum-utils

RUN touch /etc/yum.repos.d/nginx.repo

# /etc/yum.repos.d/nginx.repo

RUN echo '[nginx-stable]' >> /etc/yum.repos.d/nginx.repo
RUN echo 'name=nginx stable repo' >> /etc/yum.repos.d/nginx.repo
RUN echo 'baseurl=http://nginx.org/packages/centos/$releasever/$basearch/' >> /etc/yum.repos.d/nginx.repo
RUN echo 'gpgcheck=1' >> /etc/yum.repos.d/nginx.repo
RUN echo 'enabled=1' >> /etc/yum.echo 'name=nginx mainline repo' >> /etc/yum.repos.d/nginx.repo
RUN echo 'gpgkey=https://nginx.org/keys/nginx_signing.key' >> /etc/yum.repos.d/nginx.repo
RUN echo 'module_hotfixes=true' >> /etc/yum.repos.d/nginx.repo
RUN echo '' >> /etc/yum.repos.d/nginx.repo
RUN echo '[nginx-mainline]' >> /etc/yum.repos.d/nginx.repo
RUN echo 'name=nginx mainline repo' >> /etc/yum.repos.d/nginx.repo
RUN echo 'baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/' >> /etc/yum.repos.d/nginx.repo
RUN echo 'gpgcheck=1' >> /etc/yum.repos.d/nginx.repo
RUN echo 'enabled=0' >> /etc/yum.repos.d/nginx.repo
RUN echo 'gpgkey=https://nginx.org/keys/nginx_signing.key' >> /etc/yum.repos.d/nginx.repo
RUN echo 'module_hotfixes=true' >> /etc/yum.repos.d/nginx.repo

#

RUN yum install -y nginx

###

### php, php-fpm install

RUN yum install -y php php-xml php-json php-mbstring php-gd php-mysqlnd php-zip

###

### php configuration

## /etc/php-fpm.d/www.conf

RUN sed -i -e '24c user = nginx' 			/etc/php-fpm.d/www.conf
RUN sed -i -e '26c group = nginx' 			/etc/php-fpm.d/www.conf
RUN sed -i -e '48c listen.owner = nginx' 		/etc/php-fpm.d/www.conf
RUN sed -i -e '49c listen.group = nginx' 		/etc/php-fpm.d/www.conf
RUN sed -i -e '50c listen.mode = 0660' 			/etc/php-fpm.d/www.conf
RUN sed -i -e '55c ;listen.acl_user = apache,nginx'     /etc/php-fpm.d/www.conf

###

### mariadb install

RUN yum install -y mariadb mariadb-server

###

### wordpress install

RUN curl -OL https://wordpress.org/latest.tar.gz
RUN tar -xf latest.tar.gz
RUN mv wordpress /usr/share/nginx/html
RUN chmod 755 /usr/share/nginx/html/wordpress
RUN chown -R nginx:nginx /usr/share/nginx/html/wordpress

# if localhost: is corrctly shown, nginx works well
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/wordpress/index.html

## wp-config.php

RUN cp /usr/share/nginx/html/wordpress/wp-config-sample.php /usr/share/nginx/html/wordpress/wp-config.php

## /etc/nginx/conf.d/default.conf
RUN sed -i -e '3c #server_name  localhost; ' /etc/nginx/conf.d/default.conf
RUN sed -i -e '8c  root /usr/share/nginx/html/wordpress; ' /etc/nginx/conf.d/default.conf
RUN sed -i -e '18c root /usr/share/nginx/html/wordpress; ' /etc/nginx/conf.d/default.conf
RUN sed -i -e '29c location ~ \.php$ {' /etc/nginx/conf.d/default.conf
RUN sed -i -e '30c root           /usr/share/nginx/html/wordpress;' /etc/nginx/conf.d/default.conf
RUN sed -i -e '31c fastcgi_pass   unix:/run/php-fpm/www.sock;' /etc/nginx/conf.d/default.conf
RUN sed -i -e '32c fastcgi_index  index.php;' /etc/nginx/conf.d/default.conf
RUN sed -i -e '33c fastcgi_param  SCRIPT_FILENAME   $document_root$fastcgi_script_name;' /etc/nginx/conf.d/default.conf
RUN sed -i -e '34c include        fastcgi_params;' /etc/nginx/conf.d/default.conf
RUN sed -i -e '35c }' /etc/nginx/conf.d/default.conf
##

## /etc/nginx/conf.d/wordpress.conf
RUN touch /etc/nginx/conf.d/wordpress.conf
RUN echo 'server {' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'listen 80 default_server;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'server_name wordpress.net;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'root /usr/share/nginx/html/wordpress;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'index index.php;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '# 413 Request Entity Too Large' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'client_max_body_size 20M;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '' >> /etc/nginx/conf.d/wordpress.conf
RUN echo ' # パーマネントリンク設定' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'try_files $uri $uri/ /index.php?$args;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '# wp-config.phpへのアクセス拒否設定' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'location ~* /wp-config.php {' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'deny all;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '}' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '# php-fpm用設定' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'location ~ \.php$ {' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'fastcgi_pass unix:/run/php-fpm/www.sock;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'fastcgi_param PATH_INFO $fastcgi_script_name;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'include fastcgi_params;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '}' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '# クライアントキャッシュ' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '# ログを除外' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'location ~ .*\.(jpg|gif|png|css|js|ico|woff) {' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'expires 10d;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'access_log off;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo 'log_not_found off;' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '}' >> /etc/nginx/conf.d/wordpress.conf
RUN echo '}' >> /etc/nginx/conf.d/wordpress.conf
##

###

RUN yum install -y epel-release
RUN yum install -y pwgen

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

ADD ./readme.sh /readme.sh
RUN chmod 755 /readme.sh

EXPOSE 3306

RUN sh readme.sh