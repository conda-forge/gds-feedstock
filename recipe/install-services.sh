#!/bin/bash

install_dirs=(
Triggers/trig
Services/AlarmClient
Services/AlarmMgr
Services/AppClient
Services/AppServer
Services/MonClient
Services/MonServer
Services/NameClient
Services/NameServer
Services/TrigClient
Services/TrigMgr
)

pushd _build
set -ex
for dir_ in ${install_dirs[@]}; do
    make -j ${CPU_COUNT} V=1 VERBOSE=1 install -C ${dir_}
done

# install libserver.so
make -j ${CPU_COUNT} V=1 VERBOSE=1 -C Services install-exec-am lib_LTLIBRARIES="libserver.la"
