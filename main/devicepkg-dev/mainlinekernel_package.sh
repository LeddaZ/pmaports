#!/bin/sh

# Parse arguments
builddir=$1
pkgdir=$2
_carch=$3
_flavor=$4
_outdir=$5

if [ -z "$builddir" ] || [ -z "$pkgdir" ] || [ -z "$_carch" ] ||
	[ -z "$_flavor" ]; then
	echo "ERROR: missing argument!"
	echo "Please call mainlinekernel_package() with \$builddir, \$pkgdir,"
	echo "\$_carch, \$_flavor (and optionally \$_outdir) as arguments."
	exit 1
fi

case "$_carch" in
		arm*|riscv*) _install="zinstall dtbs_install" ;;
		*) _install="install" ;;
esac

make modules_install "$_install" \
	ARCH="$_carch" \
	LLVM=1 \
	INSTALL_PATH="$pkgdir"/boot/ \
	INSTALL_MOD_PATH="$pkgdir"/usr \
	INSTALL_MOD_STRIP=1 \
	INSTALL_DTBS_PATH="$pkgdir"/boot/dtbs-"$_flavor"

rm -f "$pkgdir"/lib/modules/*/build "$pkgdir"/lib/modules/*/source

install -D "$builddir"/include/config/kernel.release \
	"$pkgdir"/usr/share/kernel/"$_flavor"/kernel.release
