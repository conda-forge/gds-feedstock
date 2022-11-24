#!/bin/bash

pushd _build
set -ex

# build the Services subdir, but not libclient.so (part of gds-base-crtools)
make -j ${CPU_COUNT} V=1 VERBOSE=1 \
  -C Services \
  install-exec-am \
  install-lib_pkgconfigDATA \
  lib_LTLIBRARIES="libmonitor.la libtclient.la" \
;
