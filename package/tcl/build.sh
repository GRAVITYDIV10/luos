#!/usr/bin/env ash

export LUOS_PKGVER=8.6.14
. ../../utils.sh

cd ${LUOS_PKGBUILD}/unix || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	--mandir=/usr/share/man || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
