#!/usr/bin/env ash

export LUOS_PKGVER=8.6.0
. ../../utils.sh

set_if_noset OPENSSL_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} openssl)"
set_if_noset ZLIB_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} zlib)"

err_if_not_found "${OPENSSL_PKGROOT}" "package openssl not found"
err_if_not_found "${ZLIB_PKGROOT}" "package zlib not found"

cd ${LUOS_PKGBUILD} || exit 1
autoreconf -fi || exit 1
./configure \
	--with-openssl \
	--without-libpsl \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	CFLAGS="-I${OPENSSL_PKGROOT}/usr/include\
		-I${ZLIB_PKGROOT}/usr/include" \
	LDFLAGS="-L${OPENSSL_PKGROOT}/usr/lib\
		-L${ZLIB_PKGROOT}/usr/lib" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
