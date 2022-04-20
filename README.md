# Wordpress-Dockerfile-Nginx-PHP-fpm-Mariadb

You can use Wordpress with the Dockerfile

How to start (this is written also in readme.sh)
1. download Dockerfile, start.sh, readme.sh in the same directory

2. run these commands below at the directory
  * build up the image from Dockerfile  
  command: `docker build -t name .`

  * build up the container  
  command: `docker run -d -privileged -p NUM:80 --name NAME NAME_IMAGE /sbin/init`  
  (need -privileged to run systemctl)  
  (port:NUM is needed when you visit wordpress via localhost)  
  
  * **if you use macOS with mac chip, run this command instead**  
  command: `docker run -d --privileged --cgroupns=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw -p NUM:NUM --name NAME NAME_IMAGE /sbin/init`  
  
  * get into the docker container  
  command: `docker exec -it NAME /bin/bash`  

3. run this command in the container  
  command: `sh start.sh`  
  * input the database name. this database is for wordpress  
  * remember *your new mysql password*  
  * *enter **nothing** for current password*  
  * answer **Y** for *Set root password*  
  * enter the *your new mysql password*  
  * answer **Y** to the all questions  

4. visit the wordpress  
  * start your wordpress with the url below
  * **localhost:NUM/wp-admin/install.php**
