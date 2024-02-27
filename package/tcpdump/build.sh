#!/usr/bin/env ash

export LUOS_PKGVER=4.99.4
. ../../utils.sh

set_if_noset LIBPCAP_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} libpcap)"

err_if_not_found "${LIBPCAP_PKGROOT}" "package libpcap not found"

cd ${LUOS_PKGBUILD} || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	CFLAGS="-I${LIBPCAP_PKGROOT}/usr/include"
	LDFLAGS="-L${LIBPCAP_PKGROOT}/usr/lib -lpcap" || exit 1
make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}"|| exit 1
