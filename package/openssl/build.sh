#!/usr/bin/env ash

export PKGVER=3.2.1
. ../../utils.sh

set -eu
cd ${PKGBUILD}
./Configure linux-generic64 shared \
	--cross-compile-prefix=${CROSS_COMPILE}- \
	--prefix=/usr --openssldir=/etc/ssl

make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
