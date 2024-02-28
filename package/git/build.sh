#!/usr/bin/env ash

export LUOS_PKGVER=2.44.0
. ../../utils.sh

set_if_noset CURL_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} curl)"
set_if_noset OPENSSL_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} openssl)"
set_if_noset ZLIB_PKGROOT "$(find_pkg_root ${LUOS_TMPDIR} zlib)"

err_if_not_found "${CURL_PKGROOT}" "package curl not found"
err_if_not_found "${OPENSSL_PKGROOT}" "package openssl not found"
err_if_not_found "${ZLIB_PKGROOT}" "package zlib not found"


cd ${LUOS_PKGBUILD} || exit 1
make configure || exit 1
ac_cv_fread_reads_directories=yes \
ac_cv_snprintf_returns_bogus=yes \
ac_cv_prog_CURL_CONFIG=$(which false) \
ac_cv_iconv_omits_bom=no \
./configure \
	$(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) \
	--with-curl \
	CFLAGS="-I${CURL_PKGROOT}/usr/include\
		-I${OPENSSL_PKGROOT}/usr/include\
		-I${ZLIB_PKGROOT}/usr/include"\
	LDFLAGS="-L${CURL_PKGROOT}/usr/lib\
		-L${OPENSSL_PKGROOT}/usr/lib\
		-L${ZLIB_PKGROOT}/usr/lib\
		-Wl,-rpath-link,${CURL_PKGROOT}/usr/lib\
		-Wl,-rpath-link,${OPENSSL_PKGROOT}/usr/lib\
		-Wl,-rpath-link,${ZLIB_PKGROOT}/usr/lib\
		-lcurl -lz" || exit 1
make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}"|| exit 1
