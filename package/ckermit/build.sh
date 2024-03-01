#!/usr/bin/env ash

export LUOS_PKGVER=10.0
. ../../utils.sh

cd ${LUOS_PKGBUILD} || exit 1
make xermit CC=${LUOS_CROSS_COMPILE}-cc \
	 "CFLAGS = -O -DLINUX -pipe -funsigned-char -DFNFLOAT -DCK_POSIX_SIG \
        -DCK_NEWTERM -DTCPSOCKET -DLINUXFSSTND -DNOCOTFMC -DPOSIX \
        -DUSE_STRERROR" || exit 1

make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
