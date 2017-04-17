#!/bin/bash

apt-get install -y curl
apt-get install -y sshpass
apt-get install -y bridge_utils
apt-get install -y lxc
apt-get install -y net-tools
apt-get install -y iproute
DEBIAN_FRONTEND=noninteractive apt-get install -y procmail
