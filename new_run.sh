#!/bin/bash

# help
help() {
    echo -e "Usage: ./new_run.sh [OPTIONS] COMMAND"
    echo -e "       ./new_run.sh [ --help] \n"
    echo -e "Automatically configuration service for cloud.\n"
    echo -e "Options: \n" 
    echo -e "   -H, --host         Use hosts groups"
    echo -e "   -h, --help         Print usage\n"
    echo -e "Commands:"
    echo -e "   init                        Initial settings"
	echo -e "	cnodecreate					Compute node create"
	echo -e "	cnodedelete					Compute node delete"
	echo -e "	csvmgrrun					Volume manager run"
	echo -e "	dbdelete					Tibero6 delete in container"
	echo -e "	dbinstall					Tibero6 install & run in container"
	echo -e "	dbmanualdelete				Tibero6 manual delete"
	echo -e "	dbmanualinstall				Tibero6 manual install"
	echo -e "	dbmanualrun					Tibero6 manual run"
	echo -e "	dockerdelete				Docker delete"
	echo -e "	iaasrun						IaaS binary run"
	echo -e "	lxcclean					Container initial"
	echo -e "	lxcinstall					LXC install"
	echo -e "	networksetting				Network NIC setting"
	echo -e "	pingexternal				Ping test external IP"
	echo -e "	pinginternal				Ping test internal IP"
	echo -e "	poinstall					PO7 install in docker"
	echo -e "	snodeadd					Storage node create"
	echo -e "	snodedelete					Storage node delete"
	echo -e "	zfsdelete					ZFS delete"
	echo -e "	zfsinstall					ZFS install"

    #echo -e "\033[1mName\033[0m"
    #echo -e "Install & configuration automatically"
    #echo -e
    #echo -e "\033[1mOPTIONS\033[0m"
    #echo -e "-h      help"
    #echo -e "-o      option"
    #echo -e 
    #echo -e "options: init / rundb / runpo / runall / delete"
    #echo -e "ex) ./run.sh -o run_all"
    exit 0
}

# set argument

while getopts "H:-host:h:-help" opt
do
    opt="$1"
    case $opt in
        -H | --host) host="$2" action="$3"
        ;;
        -h | --help) help ;;
        ?) help ;;
        *) help ;;
    esac
done

shift $(( $OPTIND -1 ))


file="$(locate '*id_rsa')"
echo $file

if [ -f "$file" ]; then
	echo "$file exists."
else
	ssh-keygen
fi


host_count=`cat $PWD/hosts | grep -v "\[" | grep -v "\#" | grep -v "^$" | grep -v "[a-z]" | grep -v "[A-Z]" | wc -l`
echo $host_count


index=1
while [ $index -le $host_count ]
do
    host_ip=`cat $PWD/hosts | grep -v "\[" | grep -v "\#" | grep -v "^$" | sed -n "$index"'p'` 
    echo $host_ip
    sudo sh -c "ssh-copy-id -i /home/jang/.ssh/id_rsa.pub root@'$host_ip' > temp"


    warning=`sed -n '/WARNING/p' temp`
    error=`sed -n '/ERROR/p' temp`
    
    if [[ "$error" =~ "ERROR" ]]; then
        echo "error"
        exit
    else
        echo "pass"
    fi

    if [[ "$warning" =~ "WARNING" ]]
    then
        echo "skip ssh copy id"
    else
        echo "pass"
    fi

    index=$(($index+1))
done


if [ "$action" = "init" ]; then
    ansible-playbook init.yml -e "hosts=$host" -v
elif [ "$action" = "cnodecreate" ]; then
	ansible-playbook cnode_create.yml -e "hosts=$host" -v
elif [ "$action" = "cnodedelete" ]; then
	ansible-playbook cnode_delete.yml -e "hosts=$host" -v
elif [ "$action" = "csvmgrrun" ]; then
	ansible-playbook csvmgr_run.yml -e "hosts=$host" -v
elif [ "$action" = "dbinstall" ]; then
	ansible-playbook db_install.yml -e "hosts=$host" -v
elif [ "$action" = "dbmanualdelete" ]; then
	ansible-playbook dbmanual_delete.yml -e "hosts=$host" -v
elif [ "$action" = "dbmanualinstall" ]; then
	ansible-playbook dbmanual_install.yml -e "hosts=$host" -v
elif [ "$action" = "dbmanualrun" ]; then
	ansible-playbook dbmanual_run.yml -e "hosts=$host" -v
elif [ "$action" = "dockerdelete" ]; then
	ansible-playbook docker_delete.yml -e "hosts=$host" -v
elif [ "$action" = "iaasrun" ]; then
	ansible-playbook iaas_run.yml -e "hosts=$host" -v
elif [ "$action" = "lxcclean" ]; then
	ansible-playbook lxc_clean.yml -e "hosts=$host" -v
elif [ "$action" = "lxcinstall" ]; then
	ansible-playbook lxc_install.yml -e "hosts=$host" -v
elif [ "$action" = "networksetting" ]; then
	ansible-playbook network_setting.yml -e "hosts=$host" -v
elif [ "$action" = "pingexternal" ]; then
	ansible-playbook ping_external.yml -e "hosts=$host" -v
elif [ "$action" = "pinginternal" ]; then
	ansible-playbook ping_internal.yml -e "hosts=$host" -v
elif [ "$action" = "poinstall" ]; then
	ansible-playbook po_install.yml -e "hosts=$host" -v
elif [ "$action" = "snodecreate" ]; then
	ansible-playbook snode_create.yml -e "hosts=$host" -v
elif [ "$action" = "snodedelete" ]; then
	ansible-playbook snode_delete.yml -e "hosts=$host" -v
elif [ "$action" = "sysmanageragent" ]; then
	ansible-playbook sysmanager_agent.yml -e "hosts=$host" -v
elif [ "$action" = "zfsdelete" ]; then
	ansible-playbook zfs_delete.yml -e "hosts=$host" -v
elif [ "$action" = "zfsinstall" ]; then
	ansible-playbook zfs_install.yml -e "hosts=$host" -v
else
    echo "Unrecongnized host : "$host "command : "$action
fi
