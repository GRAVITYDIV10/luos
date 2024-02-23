#!/usr/bin/env ash

export PKGVER=1.3.1
. ../../utils.sh

set -eu
cd ${PKGBUILD}
CC=${CROSS_COMPILE}-cc \
LD=${CROSS_COMPILE}-ld \
AR=${CROSS_COMPILE}-ar \
RANLIB=${CROSS_COMPILE}-ranlib \
./configure --prefix=/usr \
	--static --shared
make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
