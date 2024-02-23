#!/usr/bin/env ash

export PKGVER=1.36
. ../../utils.sh

set -eu
cd ${PKGBUILD}
export CROSS_COMPILE="${CROSS_COMPILE}-"
make defconfig
make -j`nproc`
make CONFIG_PREFIX="${PKGROOT}" install

make_pkg "${PKGROOT}" "${PKGOUT}"
