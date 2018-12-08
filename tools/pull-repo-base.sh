#! /usr/bin/env bash

REMOTE_REPO=$1
LOCAL_WORKSPACE_PATH=$2

# http://www.runoob.com/linux/linux-shell-test.html
# -z 字符串	字符串的长度为零则为真
# -d 文件名	如果文件存在且为目录则为真
# 或( -o )
if [ -z $REMOTE_REPO -o -z $LOCAL_WORKSPACE_PATH ]; then
    echo "invalid call pull-repo.sh '$REMOTE_REPO' '$LOCAL_WORKSPACE_PATH'"
elif [ ! -d $LOCAL_WORKSPACE_PATH ]; then
    git clone $REMOTE_REPO $LOCAL_WORKSPACE_PATH
else
    cd $LOCAL_WORKSPACE_PATH
    git fetch --all --tags
    cd --
fi
