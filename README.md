# Wordpress-Dockerfile-Nginx-PHP-fpm-Mariadb

You can use Wordpress with the Dockerfile

How to start (this is written also in readme.sh)
1. download Dockerfile, start.sh, readme.sh in the same directory

2. run these commands below at the directory
  command: docker build -t name .

  command: docker run -d -privileged -p NUM:NUM --name NAME NAME_IMAGE /sbin/init
  (need -privileged to run systemctl)

  (if you use macOS with mac chip, run this command instead)
  command: docker run -d --privileged --cgroupns=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw -p NUM:NUM NAME_IMAGE /sbin/init

3. run this command
  command: sh start.sh

