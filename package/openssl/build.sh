#!/usr/bin/env ash

export LUOS_PKGVER=3.2.1
. ../../utils.sh

if [ -z "${TGT}" ]
then
	TGT=${LUOS_OS}-generic64
fi

set -eu
cd ${LUOS_PKGBUILD}
if [ "${LUOS_ARCH}" = "riscv64" ]
then
	TGT=${LUOS_OS}64-${LUOS_ARCH}
fi
./Configure ${TGT} shared \
	--cross-compile-prefix=${LUOS_CROSS_COMPILE}- \
	--prefix=/usr --openssldir=/etc/ssl

make -j`nproc`
make DESTDIR="${LUOS_PKGROOT}" install

remove_la_files "${LUOS_PKGROOT}"
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}"
