#!/bin/bash


home=$PWD
echo $home

if [ -f $home/automation/csvmgr/setenv ]; then
    echo "skip generate"
    exit
else
    touch $home/automation/csvmgr/setenv
fi

setenv=$home/automation/csvmgr/setenv

echo "#!/bin/bash" >> $setenv
echo "export TB_HOME=$TB_HOME" >> $setenv
echo "export TB_SID=$TB_SID" >> $setenv
echo 'export LD_LIBRARY_PATH=$TB_HOME/lib:$TB_HOME/client/lib' >> $setenv
echo 'export PATH=$PATH:$TB_HOME/bin:$TB_HOME/client/bin' >> $setenv
