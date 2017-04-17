#!/bin/bash

## eth1 IP & MAC  setting
MAC=`grep -r "hwaddress" /etc/network/interfaces`
echo $MAC
if [[ "$MAC" =~ ^hwaddress* ]]; then
	echo "There are MAC & IP address settings"
else
	inaddress=`ip addr | grep "eno2" | grep "inet " | grep brd | awk '{print $2}' | awk -F/ '{print $1}'`
	i=`grep -n $inaddress iphost | cut -d: -f1 | awk NR==1`
	address=`awk 'NR=="'"$i"'"{print $3}' iphost`
	pmac=`awk 'NR=="'"$i"'"{print $4}' iphost`
	
	if [ "$address" == "172.18.0.2" ]; then
		sudo sed -i -e "/iface lo /a dns-nameservers 8.8.8.8 " /etc/network/interfaces
        sudo sed -i -e "/iface lo /a gateway 172.18.0.1 " /etc/network/interfaces
        sudo sed -i -e "/iface lo /a broadcast 172.18.255.255 " /etc/network/interfaces
        sudo sed -i -e "/iface lo /a network 172.18.0.0 " /etc/network/interfaces
        sudo sed -i -e "/iface lo /a netmask 255.255.0.0 " /etc/network/interfaces
    
        sudo sed -i -e "/iface lo /a hwaddress ether $pmac" /etc/network/interfaces
        sudo sed -i -e "/iface lo /a address $address" /etc/network/interfaces
        sudo sed -i -e "/iface lo /a iface eno1 inet static" /etc/network/interfaces
        sudo sed -i -e "/iface lo /a auto eno1" /etc/network/interfaces
        sudo sed -i -e "/iface lo / a\\ " /etc/network/interfaces
	else
		sudo sed -i -e "/iface lo /a dns-nameservers 8.8.8.8 " /etc/network/interfaces
		sudo sed -i -e "/iface lo /a gateway 172.19.0.1 " /etc/network/interfaces
		sudo sed -i -e "/iface lo /a broadcast 172.19.255.255 " /etc/network/interfaces
		sudo sed -i -e "/iface lo /a network 172.19.0.0 " /etc/network/interfaces
		sudo sed -i -e "/iface lo /a netmask 255.255.0.0 " /etc/network/interfaces
	
		sudo sed -i -e "/iface lo /a hwaddress ether $pmac" /etc/network/interfaces
		sudo sed -i -e "/iface lo /a address $address" /etc/network/interfaces
		sudo sed -i -e "/iface lo /a iface eno1 inet static" /etc/network/interfaces
		sudo sed -i -e "/iface lo /a auto eno1" /etc/network/interfaces
		sudo sed -i -e "/iface lo / a\\ " /etc/network/interfaces
	fi
	## init.d networking restart
	sudo /etc/init.d/networking restart

	sleep 7
fi

