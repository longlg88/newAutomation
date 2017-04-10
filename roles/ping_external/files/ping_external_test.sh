#!/bin/bash

time=`date +%Y%m%d%H%M`

this_ip=`ifconfig eno1 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`

success_file="logfile_external_"$time"_"$this_ip"_SUCCESS"
fail_file="logfile_external_"$time"_"$this_ip"_FAIL"

sudo touch $success_file
sudo touch $fail_file

address="8.8.8.8"
ping -c 3 $address 
if [ $? -eq 0 ]; then
	echo -e "ping to "$address " OK!\n" >> $success_file
elif [ $? -eq 2 ]; then
	echo -e "no response from "$address"\n" >> $fail_file
else
	echo -e "ping to "$address" failed!\n" >> $fail_file
fi

scp $success_file $ANSIBLE_HOST
scp $fail_file $ANSBILE_HOST

rm -f $success_file
rm -f $fail_file
