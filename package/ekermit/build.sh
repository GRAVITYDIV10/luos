#!/usr/bin/env ash

export PKGVER=1.8
. ../../utils.sh

set -eu
cd ${PKGBUILD}
mkdir -pv "${PKGROOT}/usr/bin"
make CC=${CROSS_COMPILE}-cc ek
cp -vf ./ek "${PKGROOT}/usr/bin/ek"

make_pkg "${PKGROOT}" "${PKGOUT}"
