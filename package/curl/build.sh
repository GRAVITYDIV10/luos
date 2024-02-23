#!/usr/bin/env ash

export PKGVER=8.6.0
. ../../utils.sh

set -eu
cd ${PKGBUILD}
autoreconf -fi
./configure \
	${GNU_CONFIGURE_OPTS} \
	--with-openssl \
	--without-libpsl \
	CFLAGS="-I$(find_pkg_root ${TMPDIR} openssl)/usr/include -I$(find_pkg_root ${TMPDIR} zlib)/usr/include" \
	LDFLAGS="-L$(find_pkg_root ${TMPDIR} openssl)/usr/lib -L$(find_pkg_root ${TMPDIR} zlib)/usr/lib"

make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
