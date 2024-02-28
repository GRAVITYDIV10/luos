#!/usr/bin/env sh

pkgname=${1}
pkgversion=${2}

if [ -z "${2}" ]
then
	echo "usage: pkgname version"
	exit 1
fi

set -u

echo "https://mirrors.tuna.tsinghua.edu.cn/pkgsrc/distfiles/
https://mirrors.bfsu.edu.cn/pkgsrc/distfiles/
https://mirrors.tuna.tsinghua.edu.cn/gentoo/distfiles/
https://mirrors.bfsu.edu.cn/gentoo/distfiles/" | while read url_prefix
do
	echo ".tar.gz
	.tar.xz
	.tar.bz2
	.tar.lz4
	.tar.lz
	.zip
	.7z" | while read url_suffix
	do
		echo "_
		-
		-v
		_v" | while read url_middle
		do
			filename=${pkgname}${url_middle}${pkgversion}${url_suffix}
			echo ${url_prefix}${filename}
		done
	done
done
