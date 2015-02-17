#!/bin/bash


###
# openSUSE 
# 192.168.56.120
###

zypper in postgresql postgresql-server postgresql-contrib
zypper in vsftpd git-core

# vsftpd
git clone https://github.com/Kanst/assa.git /home/assa/
useradd assa
passwd assa
chown -R assa /home/assa
sed -i 's/#seccomp_sandbox=NO/seccomp_sandbox=NO/g' /etc/vsftpd.conf 
sed -i '/write_enable=/s/NO/YES/' /etc/vsftpd.conf 
systemctl restart vsftpd.service


# Создание базы и пользователя (работаем от пользователя postgres)
sed -i  '/listen_addresses = /s/localhost/*/' /var/lib/pgsql/data/postgresql.conf  
sed -i 's/#log_duration = off/log_duration = on/g' /var/lib/pgsql/data/postgresql.conf
sed -i 's/#log_min_duration_statement = -1/log_min_duration_statement = 0/g' /var/lib/pgsql/data/postgresql.conf

createuser assa
createdb -O assa assa

# psql
psql -c "ALTER USER assa WITH PASSWORD 'assa';"
