#!/usr/bin/env ash

export LUOS_PKGVER=2.10
. ../../utils.sh

set_if_noset OPENSSL_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} openssl)"
set_if_noset LIBNL_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} libnl)"
set_if_noset DBUS_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} dbus)"

err_if_not_found "${OPENSSL_PKGROOT}" "package openssl not found"
err_if_not_found "${LIBNL_PKGROOT}" "package libnl not found"
err_if_not_found "${DBUS_PKGROOT}" "package dbus not found"

hostap_config() {
	echo "CFLAGS += -I${OPENSSL_PKGROOT}/usr/include"
	echo "LIBS += -L${OPENSSL_PKGROOT}/usr/lib -lssl -lcrypto"
	echo "CFLAGS += -I${LIBNL_PKGROOT}/usr/include"
	echo "LIBS += -L${LIBNL_PKGROOT}/usr/lib -lnl-3"
	echo "CFLAGS += -I${DBUS_PKGROOT}/usr/include"
	echo "LIBS += -L${DBUS_PKGROOT}/usr/lib -ldbus-1"
	echo "LIBDIR = /usr/lib"
	echo "INCDIR = /usr/include"
	echo "BINDIR = /usr/sbin"
}

cd ${LUOS_PKGBUILD} || exit 1
cd wpa_supplicant || exit 1
cp defconfig .config || exit 1
hostap_config >> .config

make CC=${LUOS_CROSS_COMPILE}-cc -j`nproc` || exit 1
make PREFIX=/usr DESTDIR=${LUOS_PKGROOT} install || exit 1

cd ../hostapd || exit 1
cp defconfig .config || exit 1
hostap_config >> .config

make CC=${LUOS_CROSS_COMPILE}-cc -j`nproc` || exit 1
make PREFIX=/usr DESTDIR=${LUOS_PKGROOT} install || exit 1

make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
