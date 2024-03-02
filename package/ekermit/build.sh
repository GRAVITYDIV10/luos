#!/usr/bin/env ash

export LUOS_PKGVER=1.18
. ../../utils.sh

cd ${LUOS_PKGBUILD} || exit 1
mkdir -pv "${LUOS_PKGROOT}/usr/bin" || exit 1
make CC=${LUOS_CROSS_COMPILE}-cc ek || exit 1
cp -vf ./ek "${LUOS_PKGROOT}/usr/bin/ek" || exit 1

make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
