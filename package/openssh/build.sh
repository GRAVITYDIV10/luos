#!/usr/bin/env ash

export PKGVER=9.6p1
. ../../utils.sh

set -eu
cd ${PKGBUILD}
automake
autoreconf
./configure ${GNU_CONFIGURE_OPTS}
make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
