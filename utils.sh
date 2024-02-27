#!/usr/bin/env ash
# shellcheck shell=dash

git_get_commit() {
	if [ -z "${1}" ]
	then
		return 1
	fi
        olddir=$(pwd)
        cd "${1}"
        git rev-parse HEAD
        cd "${olddir}"
	return 0
}

make_pkg() {
	mksquashfs "${1}" "${2}" \
		-comp lz4 -Xhc -reproducible \
		-mkfs-time 0 -fstime 0 -all-time 0 \
		-all-root -exit-on-error \
		-info -no-progress || return 1
	return 0
}

err_if_noset() {
	if [ -z "$(printenv "${1}")" ]
	then
		echo "${1}: ${2}"
		exit 1
	fi
}

set_if_noset() {
	if [ -z "$(printenv "${1}")" ]
	then
		export "${1}"="${2}"
	fi
}

err_if_not_found() {
	if [ ! -e "${1}" ]
	then
		echo "${1}: ${2}"
		exit 1
	fi
}

create_dir_if_not_found() {
	if [ ! -e "${1}" ]
	then
		mkdir -pv "${1}"
	fi
}

delete_if_found() {
	if [ -e "${1}" ]
	then
		rm -rf "${1}"
	fi
}

find_pkg_root() {
	err_if_not_found "${1}"
	find "$(realpath "${1}")" -name "${2}-*-root" -type d -maxdepth 1 | sort -V
}

remove_la_files() {
	find "$(realpath "${1}")" -name '*.la' -delete
}

meson_gen_cross_file() {
	echo "[binaries]"
	echo "c = '${1}-cc'"
	echo "cpp = '${1}-c++'"
	echo "ar = '${1}-ar'"
	echo ""
	echo "[host_machine]"
	echo "system = '${4}'"
	echo "cpu_family = '${2}'"
	echo "cpu = '${2}'"
	echo "endian = '${3}'"
}

autoconf_gen_cross_args() {
	echo -n "--prefix=/usr "
	echo -n "--sysconfdir=/etc "
	echo -n "--localstatedir=/var "
	echo -n "--libdir=/usr/lib "
	echo -n "--localstatedir=/var "
	echo -n "--libdir=/usr/lib "
	echo -n "--host=${1} "
	echo -n "--enable-shared "
	echo -n "--enable-static "
	echo -n "PKG_CONFIG=$(which false) "
}

set_if_noset LUOS_TOPDIR "$(realpath "$(dirname "$(realpath "${0}")")"/../../)"
err_if_noset LUOS_CROSS_COMPILE "please set env"
set_if_noset LUOS_ARCH "$(echo "${LUOS_CROSS_COMPILE}" | awk -F'-' '{print $1}')"
set_if_noset LUOS_OS "$(echo "${LUOS_CROSS_COMPILE}" | awk -F'-' '{print $(NF - 1)}')"
set_if_noset LUOS_LIBC "$(echo "${LUOS_CROSS_COMPILE}" | awk -F'-' '{print $(NF)}')"
set_if_noset LUOS_TMPDIR "${LUOS_TOPDIR}/build/${LUOS_CROSS_COMPILE}"
set_if_noset LUOS_PKGNAME "$(basename "$(dirname "$(realpath "${0}")")")"
set_if_noset LUOS_PKGSRC "$(dirname "$(realpath "${0}")")"/"${LUOS_PKGNAME}"
err_if_not_found "${LUOS_PKGSRC}" "please check env LUOS_PKGSRC"
set_if_noset LUOS_PKGVER "$(git_get_commit "${LUOS_PKGSRC}")"
set_if_noset LUOS_PKGVER "$(date +%Y%m%d%H%M)"
set_if_noset LUOS_PKGBUILD "${LUOS_TMPDIR}/${LUOS_PKGNAME}"
create_dir_if_not_found "$(dirname "${LUOS_PKGBUILD}")"
delete_if_found "${LUOS_PKGBUILD}"
cp -rf "${LUOS_PKGSRC}" "${LUOS_PKGBUILD}" || exit 1
set_if_noset LUOS_PKGROOT "${LUOS_TMPDIR}/${LUOS_PKGNAME}-${LUOS_PKGVER}-root"
create_dir_if_not_found "${LUOS_PKGROOT}"
set_if_noset LUOS_PKGFMT "sqfs"
set_if_noset LUOS_PKGOUT "${LUOS_TMPDIR}/${LUOS_PKGNAME}-${LUOS_PKGVER}.${LUOS_PKGFMT}"
delete_if_found "${LUOS_PKGOUT}"
