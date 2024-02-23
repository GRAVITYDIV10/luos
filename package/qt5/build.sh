#!/usr/bin/env ash

export PKGVER=5.12
. ../../utils.sh

set -eu
cd ${PKGBUILD}
./configure \
	-device linux-generic-g++\
	-device-option CROSS_COMPILE=${CROSS_COMPILE}-\
	-prefix /usr/qt5\
	-c++std c++14\
	-opensource -confirm-license\
	-shared -no-opengl -gui -widgets\
	-qpa linuxfb -linuxfb
make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
