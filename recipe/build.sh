#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

set -ex

mkdir -p _build
pushd _build

# set missing flags
export CFLAGS="-Werror=implicit-function-declaration -D_BSD_SOURCE -D_POSIX_C_SOURCE=199309L -DM_PI=3.14159265358979323846 ${CFLAGS}"
if  [[ "$(uname)" == "Darwin" ]]; then
	# required for TCP_KEEPALIVE
	export CFLAGS="-D_DARWIN_C_SOURCE ${CFLAGS}"
fi

# configure
${SRC_DIR}/configure \
	--disable-dmtviewer \
	--disable-dtt \
	--disable-monitors \
	--disable-online \
	--disable-only-dtt \
	--disable-static \
	--disable-silent-rules \
	--enable-dmt-runtime \
	--enable-online \
	--includedir=${PREFIX}/include/gds \
	--prefix="${PREFIX}" \
	--with-jsoncpp="${PREFIX}" \
	--without-hdf5 \
	--without-sasl \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1

# check (only when not cross compiling)
if [[ $build_platform == $target_platform ]]; then
	make -j ${CPU_COUNT} V=1 VERBOSE=1 check
fi
