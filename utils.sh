#!/usr/bin/env ash
# shellcheck shell=dash

git_get_commit() {
	if [ -z "${1}" ]
	then
		return 1
	fi
	set -eu
        olddir=$(pwd)
        cd "${1}"
        git rev-parse HEAD
        cd "${olddir}"
	set +eu
	return 0
}

make_pkg() {
	set -eu
	mksquashfs "${1}" "${2}" \
		-comp lz4 -Xhc -reproducible \
		-mkfs-time 0 -fstime 0 -all-time 0 \
		-all-root -exit-on-error \
		-info -no-progress || return 1
	set +eu
	return 0
}

err_if_noset() {
	set -eu
	if [ -z "$(printenv "${1}")" ]
	then
		echo "${1}: ${2}"
		exit 1
	fi
	set +eu
}

set_if_noset() {
	set -eu
	if [ -z "$(printenv "${1}")" ]
	then
		export "${1}"="${2}"
	fi
	set +eu
}

err_if_not_found() {
	set -eu
	if [ ! -e "${1}" ]
	then
		echo "${1}: ${2}"
		exit 1
	fi
	set +eu
}

create_dir_if_not_found() {
	set -eu
	if [ ! -e "${1}" ]
	then
		mkdir -pv "${1}"
	fi
	set +eu
}

delete_if_found() {
	set -eu
	if [ -e "${1}" ]
	then
		rm -rf "${1}"
	fi
	set +eu
}

find_pkg_root() {
	set -eu
	err_if_not_found "${1}"
	find "$(realpath "${1}")" -name "${2}-*-root" -type d -maxdepth 1 | sort -V
	set +eu
}

remove_la_files() {
	set -eu
	find "$(realpath "${1}")" -name '*.la' -delete
	set +eu
}

meson_gen_cross_file() {
	echo "[binaries]"
	echo "c = '${1}-cc'"
	echo "cpp = '${1}-c++'"
	echo "ar = '${1}-ar'"
	echo ""
	echo "[host_machine]"
	echo "system = 'linux'"
	echo "cpu_family = '${2}'"
	echo "cpu = '${2}'"
	echo "endian = '${3}'"
}

set_if_noset TOPDIR "$(realpath "$(dirname "$(realpath "${0}")")"/../../)"
err_if_noset CROSS_COMPILE "please set env"
set_if_noset ARCH "$(echo "${CROSS_COMPILE}" | awk -F'-' '{print $1}')"
set_if_noset TMPDIR "${TOPDIR}/build/${CROSS_COMPILE}"
set_if_noset PKGNAME "$(basename "$(dirname "$(realpath "${0}")")")"
set_if_noset PKGSRC "$(dirname "$(realpath "${0}")")"/"${PKGNAME}"
err_if_not_found "${PKGSRC}" "please check env PKGSRC"
set_if_noset PKGVER "$(git_get_commit "${PKGSRC}")"
set_if_noset PKGVER "$(date +%Y%m%d%H%M)"
set_if_noset PKGBUILD "${TMPDIR}/${PKGNAME}"
create_dir_if_not_found "$(dirname "${PKGBUILD}")"
delete_if_found "${PKGBUILD}"
cp -rf "${PKGSRC}" "${PKGBUILD}" || exit 1
set_if_noset PKGROOT "${TMPDIR}/${PKGNAME}-${PKGVER}-root"
create_dir_if_not_found "${PKGROOT}"
set_if_noset PKGFMT "sqfs"
set_if_noset PKGOUT "${TMPDIR}/${PKGNAME}-${PKGVER}.${PKGFMT}"
delete_if_found "${PKGOUT}"

export GNU_CONFIGURE_OPTS="
${GNU_CONFIGURE_OPTS} \
--prefix=/usr --sysconfdir=/etc \
--localstatedir=/var --libdir=/usr/lib \
--host=${CROSS_COMPILE} \
--enable-shared --enable-static "
