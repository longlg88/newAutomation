#!/bin/bash

time=`date +%Y%m%d%H%M`

this_ip=`ifconfig eno1 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`

file="log"
success_file="logfile_internal_"$time"_"$this_ip"_SUCCESS"
fail_file="logfile_internal_"$time"_"$this_ip"_FAIL"

sudo touch $success_file
sudo touch $fail_file

line=`wc -l < iphost`
echo $line

for (( i=2; i<=$line; i++ ))
do
	address=`awk 'NR=="'"$i"'"{print $2}' iphost`
	ping -c 3 $address 
	if [ $? -eq 0 ]; then
		echo -e "ping to "$address " OK!\n" >> $success_file
	elif [ $? -eq 2 ]; then
		echo -e "no response from "$address"\n" >> $fail_file
	else
		echo -e "ping to "$address" failed!\n" >> $fail_file
	fi
done

scp $success_file $ANSIBLE_HOST
scp $fail_file $ANSIBLE_HOST

rm -f $success_file
rm -f $fail_file
