#!/usr/bin/env ash

export LUOS_PKGVER=1.14.10
. ../../utils.sh

set_if_noset LIBEXPAT_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} libexpat)"

err_if_not_found "${LIBEXPAT_PKGROOT}" "package libexpat not found"

cd ${LUOS_PKGBUILD} || exit 1
./autogen.sh || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	--disable-tests \
	--disable-asserts \
	--disable-xml-docs \
	--disable-doxygen-docs \
	EXPAT_CFLAGS="-I${LIBEXPAT_PKGROOT}/usr/include" \
	EXPAT_LIBS="-L${LIBEXPAT_PKGROOT}/usr/lib -lexpat" || exit 1
make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}"|| exit 1
