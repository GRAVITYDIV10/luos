#!/usr/bin/env ash

export PKGVER=2.43.2
. ../../utils.sh

set -eu
cd ${PKGBUILD}
make configure
ac_cv_fread_reads_directories=yes \
ac_cv_snprintf_returns_bogus=yes \
ac_cv_prog_CURL_CONFIG=$(find_pkg_root ${TMPDIR} curl)/bin/curl-config \
./configure \
	${GNU_CONFIGURE_OPTS} \
	--with-curl \
	CFLAGS="-I$(find_pkg_root ${TMPDIR} zlib)/usr/include\
		-I$(find_pkg_root ${TMPDIR} openssl)/usr/include\
		-I$(find_pkg_root ${TMPDIR} curl)/usr/include"\
	LDFLAGS="-L$(find_pkg_root ${TMPDIR} zlib)/usr/lib\
		-L$(find_pkg_root ${TMPDIR} openssl)/usr/lib\
		-L$(find_pkg_root ${TMPDIR} curl)/usr/lib\
		-Wl,-rpath-link,$(find_pkg_root ${TMPDIR} curl)/usr/lib\
		-Wl,-rpath-link,$(find_pkg_root ${TMPDIR} zlib)/usr/lib\
		-Wl,-rpath-link,$(find_pkg_root ${TMPDIR} openssl)/usr/lib\
		-lcurl"
make -j`nproc`
make DESTDIR="${PKGROOT}" install

remove_la_files "${PKGROOT}"
make_pkg "${PKGROOT}" "${PKGOUT}"
