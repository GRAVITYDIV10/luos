#!/usr/bin/env ash

export LUOS_PKGVER=0.6.23c
. ../../utils.sh

cd ${LUOS_PKGBUILD} || exit 1
mkdir -pv "${LUOS_PKGROOT}/usr/bin" || exit 1
${LUOS_CROSS_COMPILE}-cc empty.c -o ${LUOS_PKGROOT}/usr/bin/empty || exit 1
mkdir -pv "${LUOS_PKGROOT}/usr/share/man/man1/" || exit 1
cp -vf ./empty.1 "${LUOS_PKGROOT}/usr/share/man/man1/" || exit 1

make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
