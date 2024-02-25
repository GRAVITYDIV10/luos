#!/usr/bin/env ash

export PKGVER=29.2
. ../../utils.sh

set -eu
cd ${PKGBUILD}
./autogen.sh
./configure \
	${GNU_CONFIGURE_OPTS} \
	--without-x \
	--without-gnutls \
        CFLAGS="-I$(find_pkg_root ${TMPDIR} ncurses)/usr/include\
        	-L$(find_pkg_root ${TMPDIR} ncurses)/usr/lib\
		-lncursesw"\
	PKG_CONFIG="/bin/false"

make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
