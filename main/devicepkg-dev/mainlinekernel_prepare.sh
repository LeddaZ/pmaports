#!/bin/sh

if [ "$#" -ne 0 ]; then
	echo "ERROR: mainlinekernel_prepare should be sourced in APKBUILDs."
	exit 1
fi

# Set _outdir to "." if not set
if [ -z "$_outdir" ]; then
	_outdir="."
fi

# Set _hostcc when HOSTCC is set
[ -z "$HOSTCC" ] || _hostcc="HOSTCC=$HOSTCC"

# Prepare kernel config
# shellcheck disable=SC2154
mkdir -p "$builddir/$_outdir"
# shellcheck disable=SC2154
cp "$srcdir"/config-"$_flavor"."$CARCH" "$builddir"/"$_outdir"/.config
# shellcheck disable=SC2086,SC2154
make -C "$builddir" ARCH="$_carch" O="$_outdir" \
	$_hostcc oldconfig
