#!/usr/bin/env ash

export LUOS_PKGVER=1.36
. ../../utils.sh

cd ${LUOS_PKGBUILD} || exit 1
export CROSS_COMPILE="${LUOS_CROSS_COMPILE}-" || exit 1
make defconfig || exit 1
make -j`nproc` || exit 1
make CONFIG_PREFIX="${LUOS_PKGROOT}" install || exit 1

make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
