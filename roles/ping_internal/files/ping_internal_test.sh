#!/bin/bash

time=`date +%Y%m%d%H%M`

this_ip=`ifconfig eno1 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`

file="log"
success_file="logfile_internal_"$time"_"$this_ip"_SUCCESS"
fail_file="logfile_internal_"$time"_"$this_ip"_FAIL"


line=`wc -l < /root/automation/ping/iphost`
echo $line

for (( i=2; i<=$line; i++ ))
do
	address=`awk 'NR=="'"$i"'"{print $2}' iphost`
	ping -c 3 $address 
	if [ $? -eq 0 ]; then
		sudo touch $success_file
		ping -c 3 $address >> $success_file
		echo -e "ping to "$address " OK!\n" >> $success_file
	elif [ $? -eq 2 ]; then
		sudo touch $fail_file
		ping -c 3 $address >> $fail_file
		echo -e "no response from "$address"\n" >> $fail_file
	else
		sudo touch $fail_file
		ping -c 3 $address >> $fail_file
		echo -e "ping to "$address" failed!\n" >> $fail_file
	fi
done

