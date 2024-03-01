#!/usr/bin/env ash

export LUOS_PKGVER=3.4
. ../../utils.sh

set_if_noset LIBEVENT_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} libevent)"
set_if_noset NCURSES_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} ncurses)"

err_if_not_found "${LIBEVENT_PKGROOT}" "package libevent not found"
err_if_not_found "${NCURSES_PKGROOT}" "package ncurses not found"

cd ${LUOS_PKGBUILD} || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	CFLAGS="-I${LIBEVENT_PKGROOT}/usr/include"\
	LIBNCURSESW_CFLAGS="-I${NCURSES_PKGROOT}/usr/include"\
        LDFLAGS="-L${LIBEVENT_PKGROOT}/usr/lib"\
	LIBNCURSESW_LIBS="-L${NCURSES_PKGROOT}/usr/lib -lncursesw" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
