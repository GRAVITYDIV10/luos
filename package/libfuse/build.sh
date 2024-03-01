usr/bin/env ash

export LUOS_PKGVER=3.16.2
. ../../utils.sh

cd ${LUOS_PKGBUILD} || exit 1
meson_gen_cross_file \
       "$LUOS_CROSS_COMPILE"\
       "${LUOS_ARCH}"\
       little\
       "${LUOS_OS}" > cross.txt
meson setup build --cross-file cross.txt \
       --prefix /usr \
       -Dexamples=false \
       -Dudevrulesdir=/lib/udev/rules.d \
       -Duseroot=false \
       -Dtests=false || exit 1

ninja -C build || exit 1
DESTDIR=${LUOS_PKGROOT} ninja -C build install || exit 1

remove_la_files "${LUOS_PKGROOT}" || exit 1
make_pkg "${LUOS_PKGROOT}" "${LUOS_PKGOUT}" || exit 1
