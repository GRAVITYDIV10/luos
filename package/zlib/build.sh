#!/usr/bin/env ash

export LUOS_PKGVER=1.3.1
. ../../utils.sh

set -eu
cd ${LUOS_PKGBUILD}
export CC=${LUOS_CROSS_COMPILE}-cc 
export LD=${LUOS_CROSS_COMPILE}-ld
export AR=${LUOS_CROSS_COMPILE}-ar
export RANLIB=${LUOS_CROSS_COMPILE}-ranlib
./configure --prefix=/usr --static 
make -j`nproc`
make DESTDIR="${LUOS_PKGROOT}" install
./configure --prefix=/usr --shared
make -j`nproc`
make DESTDIR="${LUOS_PKGROOT}" install

remove_la_files "${LUOS_PKGROOT}"
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}"
