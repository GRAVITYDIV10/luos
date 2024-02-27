#!/usr/bin/env ash

export LUOS_PKGVER=29.2
. ../../utils.sh

set_if_noset NCURSES_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} ncurses)"
err_if_not_found "${NCURSES_PKGROOT}" "package ncurses not found"

cd ${LUOS_PKGBUILD} || exit 1
./autogen.sh || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	--without-x \
	--without-gnutls \
        CFLAGS="-I${NCURSES_PKGROOT}/usr/include\
        	-L${NCURSES_PKGROOT}/usr/lib\
		-lncursesw"\
	PKG_CONFIG="/bin/false" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
