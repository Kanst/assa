#!/bin/bash


###
# openSUSE 
# 192.168.56.120
###

zypper in postgresql postgresql-server postgresql-contrib
zypper in vsftpd

# vsftpd
useradd assa
passwd assa
mkdir /home/assa ; chown -R assa /home/assa
sed -i 's/#seccomp_sandbox=NO/seccomp_sandbox=NO/g' /etc/vsftpd.conf 
sed -i '/write_enable=/s/NO/YES/' /etc/vsftpd.conf 

# Создание базы и пользователя (работаем от пользователя postgres)
createuser assa
createdb -O assa assa
psql assa < 1_\(Cre_main\).SQL

