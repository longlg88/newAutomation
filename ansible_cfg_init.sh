#!/bin/bash

help() {
	echo -e "Usage: ./ansible_cfg_init.sh [OPTIONS]"
	echo -e "Ansible environment setting"
	echo -e "Options: \n"
	echo -e "    -h, --help			Print help"
	echo -e "    -p, --path			Enter current main directory"
	exit 0
}

while getopts "h:-help:p:-path" opt
do
	opt="$1"
	case $opt in
		-p | --path) ANSIBLE_HOME="$2" 
		;;
		-h | --help) help ;;
		?) help ;;
		*) help ;;
	esac
done

echo $ANSIBLE_HOME

## ftp connect & download file
sudo wget -m -np -nH  --ftp-user=autouser --ftp-password=tmaxcloud! ftp://192.168.2.194/auto_binary.tar.gz

sudo tar -xvf $ANSIBLE_HOME/auto_binary.tar.gz
sudo mkdir $ANSIBLE_HOME/roles/db_install_fix06/files/binary
sudo mkdir $ANSIBLE_HOME/roles/dbmanual_install/files/binary

sudo mkdir $ANSIBLE_HOME/roles/dbmanual_install/files/sql_script
sudo mkdir $ANSIBLE_HOME/roles/dbmanual_install/files/license
sudo mkdir $ANSIBLE_HOME/roles/po7_ver7_install/files/binary
sudo mkdir $ANSIBLE_HOME/roles/csvmgr_run/files/binary

sudo mv $ANSIBLE_HOME/auto_binary/db_install_fix06/* $ANSIBLE_HOME/roles/db_install_fix06/files/binary/


sudo mv $ANSIBLE_HOME/auto_binary/dbmanual_install/* $ANSIBLE_HOME/roles/dbmanual_install/files/binary

sudo mv $ANSIBLE_HOME/roles/dbmanual_install/files/binary/create_database.sql $ANSIBLE_HOME/roles/dbmanual_install/files/sql_script

sudo mv $ANSIBLE_HOME/roles/dbmanual_install/files/binary/create_table.sql $ANSIBLE_HOME/roles/dbmanual_install/files/sql_script

sudo mv $ANSIBLE_HOME/roles/dbmanual_install/files/binary/csvmgr_schema.sql $ANSIBLE_HOME/roles/dbmanual_install/files/sql_script

sudo mv $ANSIBLE_HOME/roles/dbmanual_install/files/binary/license.xml $ANSIBLE_HOME/roles/dbmanual_install/files/license

sudo mv $ANSIBLE_HOME/auto_binary/po7_ver7_install/* $ANSIBLE_HOME/roles/po7_ver7_install/files/binary

sudo mv $ANSIBLE_HOME/auto_binary/csvmgr_run/* $ANSIBLE_HOME/roles/csvmgr_run/files/binary

sudo mv $ANSIBLE_HOME/auto_binary/ping_internal/* $ANSIBLE_HOME/roles/ping_internal/files

sudo mv $ANSIBLE_HOME/auto_binary/network_setting/* $ANSIBLE_HOME/roles/network_setting/files

cfg="/etc/ansible/ansible.cfg.backup"
if [ -f "$cfg" ]; then
	echo "file found"
	sudo rm -f /etc/ansible/ansible.cfg
	sudo cp /etc/ansible/ansible.cfg.backup /etc/ansible/ansible.cfg
	echo "done"
else
	echo "file not found"
	sudo cp /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg.backup
	echo "done"
fi

# modify inventory in ansible.cfg
sudo sed -i "/^#inventory      =/c\inventory      = $ANSIBLE_HOME/hosts" /etc/ansible/ansible.cfg

# modify sudo_user in ansible.cfg
sudo sed -i '/^#sudo_user/c\sudo_user      = root' /etc/ansible/ansible.cfg

# modify roles_path in ansible.cfg
sudo sed -i "/^#roles_path/c\roles_path      = $ANSIBLE_HOME/roles" /etc/ansible/ansible.cfg

# modify log_path in ansible.cfg
sudo sed -i "/^#log_path/c\log_path      = $ANSIBLE_HOME/logs" /etc/ansible/ansible.cfg

