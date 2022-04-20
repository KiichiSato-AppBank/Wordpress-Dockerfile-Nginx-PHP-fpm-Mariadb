#!/bin/sh
echo
echo '#############################################################################################################'
echo STEP.1
echo TO BUILD UP THE CONTAINER, RUN THIS COMMAND
echo COMMAND: docker run -d -privileged -p NUM:NUM --name NAME NAME_IMAGE /sbin/init
echo PORT:3306 IS ALREADY IN USE
echo
echo IF YOU ARE USING MAC OS WITH MAC CHIP, RUN THIS COMMAND INSTEAD
echo COMMAND: docker run -d --privileged --cgroupns=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw -p NUM:NUM NAME_IMAGE /sbin/init
echo
echo
echo STEP.2
echo TO RUN SHELL COMMAND IN THE CONTAINER, RUN THIS COMMNAD
echo COMMAND: docker exec -it NAME /bin/bash
echo
echo
echo STEP.3
echo THIS IS THE FINAL STEP
echo RUN THIS COMMAND IN THE CONTAINER 
echo COMMAND: sh start.sh
echo '#############################################################################################################'
echo

