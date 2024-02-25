#!/usr/bin/env ash

export PKGVER=3.16.2
. ../../utils.sh

set -eu
cd ${PKGBUILD}
meson_gen_cross_file "$CROSS_COMPILE" "${ARCH}" little > cross.txt
meson setup build --cross-file cross.txt \
	--prefix /usr \
	-Dexamples=false \
	-Dudevrulesdir=/lib/udev/rules.d \
	-Duseroot=false \
	-Dtests=false

ninja -C build
DESTDIR=${PKGROOT} ninja -C build install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
