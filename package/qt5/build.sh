#!/usr/bin/env ash

export LUOS_PKGVER=5.12
. ../../utils.sh

set_if_noset OPENSSL_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} openssl)"
set_if_noset ALSA_LIB_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} alsa-lib)"

err_if_not_found "${OPENSSL_PKGROOT}" "package openssl not found"
err_if_not_found "${ALSA_LIB_PKGROOT}" "package alsa-lib not found"

qt5_gen_mkspec_qmake_conf() {
	echo "MAKEFILE_GENERATOR      = UNIX"
	echo "CONFIG                 += incremental"
	echo "QMAKE_INCREMENTAL_STYLE = sublib"
	echo "include(../common/linux.conf)"
	echo "include(../common/gcc-base-unix.conf)"
	echo "include(../common/g++-unix.conf)"
	echo "QMAKE_CC                = ${1}-gcc"
	echo "QMAKE_CXX               = ${1}-g++"
	echo "QMAKE_LINK              = ${1}-g++"
	echo "QMAKE_LINK_SHLIB        = ${1}-g++"
	echo "QMAKE_AR                = ${1}-ar cqs"
	echo "QMAKE_OBJCOPY           = ${1}-objcopy"
	echo "QMAKE_NM                = ${1}-nm -P"
	echo "QMAKE_STRIP             = ${1}-strip"
	echo "load(qt_config)"
}

cd ${LUOS_PKGBUILD} || exit 1
mkdir -pv qtbase/mkspecs/${LUOS_CROSS_COMPILE}/
qt5_gen_mkspec_qmake_conf ${LUOS_CROSS_COMPILE} > qtbase/mkspecs/${LUOS_CROSS_COMPILE}/qmake.conf
cp qtbase/mkspecs/linux-aarch64-gnu-g++/qplatformdefs.h qtbase/mkspecs/${LUOS_CROSS_COMPILE}/
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
