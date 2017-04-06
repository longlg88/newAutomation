#!/bin/sh

# PARAMETER SET
# 
export CSVMGR_SID="csvmgr"
export CSVMGR_IPADDR="127.0.0.1"
export CSVMGR_PORT=52000

# Meta DB connection info
export CSVMGR_META_DB_NAME="tibero"
export CSVMGR_META_DB_USER="tibero"
export CSVMGR_META_DB_PWD="tmax"

# LOG Directory
export CSVMGR_LOG_DIR="$TB_HOME/instance/$CSVMGR_SID/log"
export CSVMGR_LOG_LEVEL="DEBUG"
