#!/usr/bin/env ash

export PKGVER=9.6p1
. ../../utils.sh

set -eu
cd ${PKGBUILD}
autoreconf -fi
./configure \
	${GNU_CONFIGURE_OPTS}\
	--with-ssl-engine \
        CFLAGS="-I$(find_pkg_root ${TMPDIR} zlib)/usr/include\
                -I$(find_pkg_root ${TMPDIR} openssl)/usr/include"\
        LDFLAGS="-L$(find_pkg_root ${TMPDIR} zlib)/usr/lib\
                -L$(find_pkg_root ${TMPDIR} openssl)/usr/lib\
                -Wl,-rpath-link,$(find_pkg_root ${TMPDIR} zlib)/usr/lib\
                -Wl,-rpath-link,$(find_pkg_root ${TMPDIR} openssl)/usr/lib"
make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
