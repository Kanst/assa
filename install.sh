#!/bin/bash


###
# CentOS 7
# 188.226.198.8
###


rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
yum install postgresql94-server postgresql94-contrib

# Systemd
/usr/pgsql-9.4/bin/postgresql94-setup initdb
systemctl enable postgresql-9.4
systemctl start postgresql-9.4
# Systemd

# Создание базы и пользователя (работаем от пользователя postgres)
createuser assa
createdb -O assa assa
psql assa < 1_\(Cre_main\).SQL

