#!/usr/bin/env ash

export LUOS_PKGVER=1.47.0
. ../../utils.sh

set_if_noset LIBFUSE2_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} libfuse2)"

err_if_not_found "${LIBFUSE2_PKGROOT}" "package libfuse2 not found"

cd ${LUOS_PKGBUILD} || exit 1
./configure \
	--enable-fuse2fs \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	CFLAGS="-I${LIBFUSE2_PKGROOT}/usr/include/fuse"\
	LDFLAGS="-L${LIBFUSE2_PKGROOT}/usr/lib -lfuse" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
