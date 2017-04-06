#!/bin/bash

# destroy all lxc containers
echo == 1. Destroy containers ==
lxc_containers="$(lxc-ls)"
for container in $lxc_containers; do
	echo Destroy container : $container
	lxc-destroy -f --name $container
done

# umount 
echo == 2. Umount aufs in rw dirs ==
root_dirs="$(ls /root/tca_agent/container_root)"
for root_dir in $root_dirs; do
	echo Umount root : $root_dir
	umount /root/tca_agent/container_root/$root_dir
done

echo == 3. Umount nfs in rw dirs ==
rw_dirs="$(ls /root/tca_agent/container_rw)"
for rw_dir in $rw_dirs; do
	echo Umount rw : $rw_dir
	umount /root/tca_agent/container_rw/$rw_dir
done

# remove tca_agent meta files
echo == 4. Remove tca_agent meta files ==
rm -r /root/tca_agent/container_root/*
rm -r /root/tca_agent/container_config/*
rm -r /root/tca_agent/container_rw/*
rm -rf /root/tca_agent/image_layer/*
rm -rf /root/tca_agent/image_ref/*
rm -rf /root/tca_agent/image_tar/*

