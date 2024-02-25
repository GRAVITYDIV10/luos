#!/usr/bin/env ash

export PKGVER=6.4
. ../../utils.sh

set -eu
cd ${PKGBUILD}
./configure \
	${GNU_CONFIGURE_OPTS} \
	--enable-widec \
	--without-ada \
	--disable-stripping

make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
