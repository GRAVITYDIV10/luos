#!/usr/bin/env ash

export PKGVER=4.4.1
. ../../utils.sh

set -eu
cd ${PKGBUILD}
./autogen.sh
./configure \
	${GNU_CONFIGURE_OPTS}
make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
