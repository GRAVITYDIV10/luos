#!/usr/bin/env ash

export LUOS_PKGVER=1.3.1
. ../../utils.sh

cd ${LUOS_PKGBUILD} || exit 1
mkdir -pv "${LUOS_PKGROOT}/usr/bin" || exit 1
make CC=${LUOS_CROSS_COMPILE}-cc || exit 1
cp -vf ./vmtouch "${LUOS_PKGROOT}/usr/bin/vmtouch" || exit 1

make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
