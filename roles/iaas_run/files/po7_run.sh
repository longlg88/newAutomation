#!/bin/bash

docker load --input /root/automation/po7/$PO_IMAGE_NAME.tar

image_name=`docker images | awk '/po/{print $1}'`
image_tag=`docker images | awk '/po/{print $2}'`

#if [[ "$image_name" == *"b007"* ]]; then
#	echo "same image is here"
#else
#	cat /root/automation/po7/$PO_IMAGE_NAME.tar | docker import - $PO_IMAGE_NAME >> /root/automation/log/progress
#fi



image_id=`docker ps | awk '/new/{print $2}'`

if [ "$image_id" = "$image_name":"$image_tag" ]; then
   echo "same docker container runs here"
else
#    docker run -d -p $PO_WEBADMIN_PORT:9736 -p $PO_WEB_PORT:8080 -v /root/automation/po7/proobject7:/proobject7 -v /root/automation/proobject7/logs:/jeus8/domains/domain1/servers/ProObject7/logs -e TIBERO_IP=$TIBERO_IP -e TIBERO_USER=$TIBERO_USER -e TIBERO_PW=$TIBERO_PW -e TIBERO_PORT=$TIBERO_PORT -i -t $image_name:$image_tag >> /root/automation/log/progress
	docker run -d -p $PO_PORTAL_PORT_1:6776 -p $PO_PORTAL_PORT_2:9008 -p $PO_WEBADMIN_PORT:9736 -p $PO_WEB_PORT:8080 -v /root/automation/po7/proobject7:/proobject7 -v /root/automation/proobject7/logs:/jeus8/logs -e DOMAINNAME=$DOMAINNAME -e TIBERO_IP=$TIBERO_IP -e TIBERO_USER=$TIBERO_USER -e TIBERO_PW=$TIBERO_PW -e TIBERO_PORT=$TIBERO_PORT -it $image_name:$image_tag >> /root/automation/log/progress
fi

#docker build --tag newpo7b006v1 /root/automation/po7/
#docker load --input /root/automation/po7/po7b006v1.tar

#if [ $? -eq 0 ]; then
#    docker build --tag newpo7b006v1 /root/automation/po7/
#    if [ $? -eq 0 ]; then
#        docker run -d -p 9738:9736 -p 8808:8080 -v /root/automation/po7/proobject7:/proobject7 -v /root/automation/proobject7/logs:/jeus8/domains/domain1/servers/ProObject7/logs -i -t newpo7b006v1
#        if [ $? -eq 1 ]; then
#            echo "[Error] docker run failed" >> /root/automation/log/progress
#        fi
#    else
#        echo "[Error] docker build failed" >> /root/automation/log/progress
#    fi
#else
#    echo "[Error] docker pull failed" >> /root/automation/log/progress
#fi

