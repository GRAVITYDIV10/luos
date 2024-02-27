#!/usr/bin/env ash

set -eu
export LUOS_PKGSRC=$(${LUOS_CROSS_COMPILE}-cc -print-sysroot)
set +eu
. ../../utils.sh

set -eu
cd ${LUOS_PKGBUILD}
cp -arvf ./* "${LUOS_PKGROOT}/"
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}"
