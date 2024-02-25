#!/usr/bin/env ash

export PKGVER=5.12
. ../../utils.sh

set -eu
cd ${PKGBUILD}
./configure \
	-xplatform ${CROSS_COMPILE} \
	-extprefix ${PKGROOT}/usr/qt5\
	-prefix /usr/qt5\
	-opensource -confirm-license\
	-debug -ltcg -silent -ccache\
	-compile-examples\
	-shared -no-opengl -gui -widgets\
	-qpa linuxfb -linuxfb -ssl\
        -I$(find_pkg_root ${TMPDIR} openssl)/usr/include\
        -L$(find_pkg_root ${TMPDIR} openssl)/usr/lib
	
make -j`nproc`
make install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
