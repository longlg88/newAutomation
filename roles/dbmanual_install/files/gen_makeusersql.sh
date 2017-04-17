#!/bin/bash

if [ -f /root/automation/db_files/make_user.sql ]; then
    echo "skip generate"
    exit
else
    touch /root/automation/db_files/make_user.sql
fi

sql=/root/automation/db_files/sql_script/make_user.sql

echo "create user $TID identified by '$TPW';" >> $sql
echo "grant create sequence to $TID;" >> $sql
echo "grant create session to $TID;" >> $sql
echo "grant create table to $TID;" >> $sql
echo "exit;" >> $sql
