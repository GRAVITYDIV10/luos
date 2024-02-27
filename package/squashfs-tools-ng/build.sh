#!/usr/bin/env ash

export LUOS_PKGVER=1.2.0
. ../../utils.sh

set_if_noset LZ4_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} lz4)"
set_if_noset ZLIB_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} zlib)"

err_if_not_found "${LZ4_PKGROOT}" "package lz4 not found"
err_if_not_found "${ZLIB_PKGROOT}" "package zlib not found"

cd ${LUOS_PKGBUILD} || exit 1
./autogen.sh || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	--with-lz4 --with-zlib \
	LZ4_CFLAGS="-I${LZ4_PKGROOT}/usr/include"\
	ZLIB_CFLAGS="-I${ZLIB_PKGROOT}/usr/include"\
        LZ4_LIBS="-L${LZ4_PKGROOT}/usr/lib -llz4"\
	ZLIB_LIBS="-L${ZLIB_PKGROOT}/usr/lib -lz" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
