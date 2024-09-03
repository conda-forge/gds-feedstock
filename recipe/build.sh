#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

set -ex

mkdir -p _build
cd _build

# error on any implicit function declaration
export CFLAGS="-Werror=implicit-function-declaration ${CFLAGS}"

# use _GNU_SOURCE to get some non-standard defines on Linux
if [[ "$target_platform" == *linux* ]]; then
	export CFLAGS="${CFLAGS} -D_GNU_SOURCE"
fi

# -undefined dynamic_lookup needs to be added manually for macOS ARM64
if [[ "$target_platform" == "osx-arm64" ]]; then
	LDFLAGS="${LDFLAGS} -Wl,-undefined -Wl,dynamic_lookup"
fi

# set arguments for all make commands
_make="make
-j${CPU_COUNT}
V=1
VERBOSE=1
zlibcflags=\"-I${PREFIX}/include\"
"

# configure
${SRC_DIR}/configure \
	--disable-dmtviewer \
	--disable-dtt \
	--disable-monitors \
	--disable-only-dtt \
	--disable-static \
	--disable-silent-rules \
	--enable-dmt-runtime \
	--includedir=${PREFIX}/include/gds \
	--prefix="${PREFIX}" \
	--with-jsoncpp="${PREFIX}" \
	--without-hdf5 \
	--without-sasl \
;

# build
$_make

# check (only when not cross compiling)
if [[ "$build_platform" == "$target_platform" ]]; then
	$_make check
fi
