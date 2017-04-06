#!/bin/bash

docker import /root/automation/db_files/$DB_IMAGE_NAME.tar >> /root/automation/log/progress

image_name=`docker images | awk '/new/{print $1}'`
image_tag=`docker images | awk '/new/{print $2}'`

image_id=`docker ps | awk '/new/{print $2}'`

if [ "$image_id" = "$image_name":"$image_tag" ]; then
	echo "same docker container runs here"
else
	docker run -it -d -p $TIBERO_PORT:8629 -v /root/automation/db_files/database:/root/tibero6/database --ipc=host -e t_id=$TIBERO_USER -e t_pw=$TIBERO_PW $image_name:$image_tag /bin/bash -c /root/tibero_boot.sh >> /root/automation/log/progress
fi
