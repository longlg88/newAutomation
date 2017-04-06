#!/bin/bash

## iphosth1 IP & MAC  siphostting
MAC=`grep -r "hwaddress" /etc/network/interfaces`
echo $MAC
if [[ "$MAC" =~ ^hwaddress* ]]; then
	echo "There are MAC & IP address settings"
else
	sudo cp /etc/network/interfaces interfaces
	inaddress=`ip addr | grep "inet " | grep brd | awk '{print $2}' | awk -F/ '{print $1}'`
	i=`grep -n $inaddress iphost | cut -d: -f1`
	address=`awk 'NR=="'"$i"'"{print $3}' iphost`
	pmac=`awk 'NR=="'"$i"'"{print $4}' iphost`

	sudo sed -i -e "/iface eno1 /a dns-nameservers 8.8.8.8 " interfaces 
	sudo sed -i -e "/iface eno1 /a gateway 172.19.0.1 " interfaces
	sudo sed -i -e "/iface eno1 /a braodcast 172.19.255.255 " interfaces
	sudo sed -i -e "/iface eno1 /a network 172.19.0.0 " interfaces
	sudo sed -i -e "/iface eno1 /a netmask 255.255.0.0 " interfaces
	
	sudo sed -i -e "/iface eno1 /a hwaddress ether $pmac" interfaces
	sudo sed -i -e "/iface eno1 /a address $address" interfaces
	## init.d networking restart
fi
