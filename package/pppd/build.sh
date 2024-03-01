#!/usr/bin/env ash

export LUOS_PKGVER=2.5.0
. ../../utils.sh

set_if_noset OPENSSL_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} openssl)"

err_if_not_found "${OPENSSL_PKGROOT}" "package openssl not found"

cd ${LUOS_PKGBUILD} || exit 1
./autogen.sh || exit 1
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	--with-openssl=${OPENSSL_PKGROOT}/usr \
	CFLAGS="-I${OPENSSL_PKGROOT}/usr/include" \
	LDFLAGS="-L${OPENSSL_PKGROOT}/usr/lib" || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
