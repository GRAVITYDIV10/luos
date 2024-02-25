#!/usr/bin/env ash

export PKGVER=3.2.1
. ../../utils.sh

set -eu
cd ${PKGBUILD}
TGT=linux-generic64
if [ "${CROSS_COMPILE}" = "riscv64-unknown-linux-gnu" ]
then
	TGT=linux64-riscv64
fi
./Configure ${TGT} shared \
	--cross-compile-prefix=${CROSS_COMPILE}- \
	--prefix=/usr --openssldir=/etc/ssl

make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
