#!/usr/bin/env ash

export LUOS_PKGVER=1.13
. ../../utils.sh

set_if_noset LIBFUSE_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} libfuse)"

err_if_not_found "${LIBFUSE_PKGROOT}" "package libfuse not found"

cd ${LUOS_PKGBUILD} || exit 1
./autogen.sh || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	PKG_CONFIG="/bin/true" \
        CFLAGS="-I${LIBFUSE_PKGROOT}/usr/include/fuse3" \
	LDFLAGS="-L${LIBFUSE_PKGROOT}/usr/lib -lfuse3" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
