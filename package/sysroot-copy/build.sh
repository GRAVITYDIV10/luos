#!/usr/bin/env ash

set -eu
export PKGSRC=$(${CROSS_COMPILE}-cc -print-sysroot)
set +eu
. ../../utils.sh

set -eu
cd ${PKGBUILD}
cp -arv ./* "${PKGROOT}/"
make_pkg "${PKGROOT}" "${PKGOUT}"
