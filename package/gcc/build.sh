#!/usr/bin/env ash

export LUOS_PKGVER=13.2.0
. ../../utils.sh

set_if_noset MPFR_PKGSRC "${LUOS_PKGSRC}/../../mpfr/mpfr"
set_if_noset GMP_PKGSRC "${LUOS_PKGSRC}/../../gmp/gmp"
set_if_noset MPC_PKGSRC "${LUOS_PKGSRC}/../../mpc/mpc"

err_if_not_found "${MPFR_PKGSRC}" "src mpfr not found"
err_if_not_found "${GMP_PKGSRC}" "src gmp not found"
err_if_not_found "${MPC_PKGSRC}" "src mpc not found"

cd ${LUOS_PKGBUILD} || exit 1
set -eu
mkdir -p gmp
mkdir -p mpfr
mkdir -p mpc
cp -rf ${GMP_PKGSRC}/* gmp/
cp -rf ${MPFR_PKGSRC}/* mpfr/
cp -rf ${MPC_PKGSRC}/* mpc/
set +eu
mkdir -p build || exit 1
cd build || exit 1
../configure \
        $(autoconf_gen_cross_args ${LUOS_CROSS_COMPILE}) || exit 1

make -j`nproc` || exit 1
make DESTDIR="${LUOS_PKGROOT}" install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
