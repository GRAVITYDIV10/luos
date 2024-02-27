#!/usr/bin/env ash

export LUOS_PKGVER=1.9.4
. ../../utils.sh

cd ${LUOS_PKGBUILD} || exit 1
mkdir -pv "${LUOS_PKGROOT}/usr/bin" || exit 1
make CC=${LUOS_CROSS_COMPILE}-cc || exit 1
make PREFIX=/usr DESTDIR=${LUOS_PKGROOT} install || exit 1

make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
