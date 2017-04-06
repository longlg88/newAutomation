#!/bin/bash

home=$PWD
echo $home

if [ -f $home/automation/csvmgr/csvmgr_setenv ]; then
	echo "skip generate"
	exit
else
	touch $home/automation/csvmgr/csvmgr_setenv
fi

setenv=$home/automation/csvmgr/csvmgr_setenv

echo "#!/bin/bash" >> $setenv
echo "## Parameter set" >> $setenv
echo "export CSVMGR_SID=$CSVMGR_SID" >> $setenv
echo "export CSVMGR_IPADDR=$CSVMGR_IPADDR" >> $setenv
echo "export CSVMGR_PORT=$CSVMGR_PORT" >> $setenv

echo "## Meta DB connection info" >> $setenv
echo "export CSVMGR_META_DB_NAME=$CSVMGR_META_DB_NAME" >> $setenv
echo "export CSVMGR_META_DB_USER=$CSVMGR_META_DB_USER" >> $setenv
echo "export CSVMGR_META_DB_PWD=$CSVMGR_META_DB_PWD" >> $setenv

echo "## LOG Directory" >> $setenv
echo 'export CSVMGR_LOG_DIR=$TB_HOME/instance/$CSVMGR_SID/log' >> $setenv
echo "export CSVMGR_LOG_LEVEL=$CSVMGR_LOG_LEVEL" >> $setenv
