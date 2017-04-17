#!/bin/bash

if [ -e sppedtest.py ]; then
	echo "file exists"
else
	wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
	chmod +x speedtest.py
fi

touch /root/automation/initial/log_speed

./speedtest.py > /root/automation/initial/log_speed
