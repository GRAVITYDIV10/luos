#!/usr/bin/env ash

export LUOS_PKGVER=1.2.11
. ../../utils.sh

set_if_noset ALSA_LIB_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} alsa-lib)"
set_if_noset NCURSES_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} ncurses)"

err_if_not_found "${ALSA_LIB_PKGROOT}" "package alsa-lib not found"
err_if_not_found "${NCURSES_PKGROOT}" "package ncurses not found"

cd ${LUOS_PKGBUILD} || exit 1
autoreconf -vif || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
        CFLAGS="-I${ALSA_LIB_PKGROOT}/usr/include\
        	-I${NCURSES_PKGROOT}/usr/include\
		-L${NCURSES_PKGROOT}/usr/lib -lncursesw\
		-L${ALSA_LIB_PKGROOT}/usr/lib -lasound\
		-Wno-traditional" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
