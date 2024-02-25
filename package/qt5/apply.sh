#!/usr/bin/env ash
#shellcheck shell=dash

set -eu

srcdir="$(dirname "$(realpath "${0}")")"
cd "${srcdir}"/qt5/qtbase

git am "${srcdir}"/patches/qt5/qtbase/0001-src-fix-compile.patch
git am "${srcdir}"/patches/qt5/qtbase/0002-mkspecs-add-riscv64-unknown-linux-gnu.patch
