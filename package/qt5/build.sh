#!/usr/bin/env ash

export LUOS_PKGVER=5.12
. ../../utils.sh

set_if_noset OPENSSL_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} openssl)"
set_if_noset ALSA_LIB_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} alsa-lib)"

err_if_not_found "${OPENSSL_PKGROOT}" "package openssl not found"
err_if_not_found "${ALSA_LIB_PKGROOT}" "package alsa-lib not found"

cd ${LUOS_PKGBUILD} || exit 1
./configure \
	-xplatform ${LUOS_CROSS_COMPILE} \
	-extprefix ${LUOS_PKGROOT}/usr/qt5\
	-prefix /usr/qt5\
	-opensource -confirm-license\
	-debug -ltcg -silent -ccache\
	-compile-examples\
	-shared -no-opengl -gui -widgets\
	-qpa linuxfb -linuxfb -ssl -alsa\
	-I${OPENSSL_PKGROOT}/usr/include \
	-L${OPENSSL_PKGROOT}/usr/lib \
	-I${ALSA_LIB_PKGROOT}/usr/include \
	-L${ALSA_LIB_PKGROOT}/usr/lib || exit 1
make -j`nproc` || exit 1
make install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
