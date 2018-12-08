#! /usr/bin/env bash

echo "== config ffmpeg module =="

# http://www.runoob.com/linux/linux-shell-test.html
# -f 文件名	如果文件存在且为普通文件则为真
if [ ! -f 'config/module.sh' ]; then
    cp config/module-lite.sh config/module.sh
fi