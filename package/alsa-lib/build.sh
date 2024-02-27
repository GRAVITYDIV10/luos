#!/usr/bin/env ash

export LUOS_PKGVER=1.2.9
. ../../utils.sh

cd ${LUOS_PKGBUILD} || exit 1
autoreconf -fiv || exit 1
./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --libdir=/usr/lib \
        --localstatedir=/var \
        --libdir=/usr/lib \
        --host=${LUOS_CROSS_COMPILE} \
        PKG_CONFIG=$(which false) || exit 1
make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
