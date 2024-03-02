#!/usr/bin/env ash

export LUOS_PKGVER=0.5.2
. ../../utils.sh

set_if_noset LIBFUSE_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} libfuse)"
set_if_noset ZLIB_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} zlib)"
set_if_noset LZ4_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} lz4)"
set_if_noset XZ_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} xz)"

err_if_not_found "${LIBFUSE_PKGROOT}" "package libfuse not found"
err_if_not_found "${ZLIB_PKGROOT}" "package zlib not found"
err_if_not_found "${LZ4_PKGROOT}" "package lz4 not found"
err_if_not_found "${XZ_PKGROOT}" "package xz not found"

cd ${LUOS_PKGBUILD} || exit 1
autoreconf -fiv || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	pkgconfig_fuse3_CFLAGS="-I${LIBFUSE_PKGROOT}/usr/include/fuse3"\
	pkgconfig_fuse3_LIBS="-L${LIBFUSE_PKGROOT}/usr/lib -lfuse3"\
	CFLAGS="-I${LZ4_PKGROOT}/usr/include -I${ZLIB_PKGROOT}/usr/include\
		-I${XZ_PKGROOT}/usr/include"\
	LDFLAGS="-L${ZLIB_PKGROOT}/usr/lib -lz -L${LZ4_PKGROOT}/usr/lib -llz4\
		-L${XZ_PKGROOT}/usr/lib -llzma" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
