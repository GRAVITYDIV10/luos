#!/usr/bin/env ash

export LUOS_PKGVER=4.2.1
. ../../utils.sh

set_if_noset GMP_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} gmp)"

err_if_not_found "${GMP_PKGROOT}" "package gmp not found"

cd ${LUOS_PKGBUILD} || exit 1
autoreconf -fiv || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	CFLAGS="-I${GMP_PKGROOT}/usr/include"\
        LDFLAGS="-L${GMP_PKGROOT}/usr/lib -lgmp"\
	CC=${LUOS_CROSS_COMPILE}-cc \
	|| exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
