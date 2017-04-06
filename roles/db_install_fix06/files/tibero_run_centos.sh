#!/bin/bash


image_name=`docker images | awk '/tibero/{print $1}'`
image_tag=`docker images | awk '/tibero/{print $2}'`

if [[ "$image_name" == *"tibero"* ]]; then
	echo "same image is here"
else
	cat /root/automation/db_files/$DB_IMAGE_NAME.tar  | docker import - $DB_IMAGE_NAME >> /root/automation/log/progress
fi

image_id=`docker ps | awk '/tibero/{print $2}'`

image_name=`docker images | awk '/tibero/{print $1}'`
image_tag=`docker images | awk '/tibero/{print $2}'`

echo $image_name:$image_tag

if [ "$image_id" = "$image_name":"$image_tag" ]; then
	echo "same docker container runs here"
else
	docker run -it -d -p $TIBERO_PORT:8629 -v /root/automation/db_files/database:/root/TmaxData/tibero6/database --ipc=host -e t_id=$TIBERO_USER -e t_pw=$TIBERO_PW $image_name:$image_tag /bin/bash -c /root/tibero_boot.sh >> /root/automation/log/progress
fi
