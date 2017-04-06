#!/bin/bash

## eth1 IP & MAC  setting
MAC=`grep -r "hwaddress" /etc/network/interfaces`
echo $MAC
if [[ "$MAC" =~ ^hwaddress* ]]; then
	echo "There are MAC & IP address settings"
else
	inaddress=`ip addr | grep "inet " | grep brd | awk '{print $2}' | awk -F/ '{print $1}'`
	i=`grep -n $inaddress iphost | cut -d: -f1`
	address=`awk 'NR=="'"$i"'"{print $3}' iphost`
	pmac=`awk 'NR=="'"$i"'"{print $4}' iphost`

	sudo sed -i -e "/iface eno1 /a dns-nameservers 8.8.8.8 " /etc/network/interfaces
	sudo sed -i -e "/iface eno1 /a gateway 172.19.0.1 " /etc/network/interfaces
	sudo sed -i -e "/iface eno1 /a braodcast 172.19.255.255 " /etc/network/interfaces
	sudo sed -i -e "/iface eno1 /a network 172.19.0.0 " /etc/network/interfaces
	sudo sed -i -e "/iface eno1 /a netmask 255.255.0.0 " /etc/network/interfaces
	
	sudo sed -i -e "/iface eno1 /a hwaddress ether $pmac" /etc/network/interfaces
	sudo sed -i -e "/iface eno1 /a address $address" /etc/network/interfaces
	## init.d networking restart
	sudo /etc/init.d/networking restart
fi
