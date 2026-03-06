#!/bin/sh -e
# Copyright 2026 Aster Boese
# SPDX-License-Identifier: GPL-3.0-or-later
# Description: verify packages follow filesystem hierarchy
# https://postmarketos.org/pmb-ci

# Get list of build packages in every repo for every arch
packages="$(find ./packages/ -type f -name "*.apk" || true)"

# List invalid file paths in packaging
bad_dirs="bin etc lib sbin var"

# Exception paths to allow until packaging is moved.
# Remove when no packages use the excepted files/paths to prevent regressions.
excepts=""
# acpid
excepts="$excepts etc/acpid.d"
# akms
excepts="$excepts etc/akms.conf"
# alsa
excepts="
	$excepts
	etc/asound.conf
	var/lib/alsa
"
# cros-keyboard-map-systemd
excepts="$excepts etc/cros-keyboard-map"
# DirectFB (used by some devices)
excepts="$excepts etc/directfbrc"
# fbset
excepts="$excepts etc/fb.modes"
# postmarketos-baselayout
excepts="$excepts etc/fstab etc/motd"
# postmarketos-release
excepts="$excepts etc/issue etc/os-release"
# every devicepkg
excepts="$excepts etc/machine-info"
# tslib
excepts="$excepts etc/pointercal"
# logind
excepts="
	$excepts
	etc/sleep-inhibitor.conf
	etc/elogind/
"
# sudo
excepts="$excepts etc/sudoers"
# unudhcpd
excepts="$excepts etc/unudhcpd.conf"
# grub
excepts="
	$excepts
	etc/update-grub.conf
	etc/grub.d
"
# firmware-sony-sumire and firmware-sony-ivy
excepts="
	$excepts
	etc/wlan_macaddr0
	etc/wlan_txpower_2_4g
	etc/wlan_txpower_5g_high
	etc/wlan_txpower_5g_low
	etc/wlan_txpower_5g_mid
	etc/wlan_txpower_co1_2_4g
	etc/wlan_txpower_co1_5g_high
	etc/wlan_txpower_co1_5g_low
	etc/wlan_txpower_co1_5g_mid
	etc/wifi
"
# UPower
excepts="$excepts etc/UPower/UPower.conf"
# X11
excepts="
	$excepts
	etc/X11/Xkbmap
	etc/X11/Xwrapper.config
	etc/X11/xorg.conf.d
"
# acpi
excepts="$excepts etc/acpi"
# apk
excepts="$excepts etc/apk"
# bash-completion
excepts="$excepts etc/bash_completion.d"
# chronyd
excepts="$excepts etc/chrony/chrony.conf"
# openrc
excepts="
	$excepts
	etc/conf.d
	etc/init.d
	etc/local.d
"
# doas
excepts="$excepts etc/doas.d"
# gdm
excepts="$excepts etc/gdm"
# greetd
excepts="$excepts etc/greetd"
# hkdm
excepts="$excepts etc/hkdm"
# iwd
excepts="$excepts etc/iwd"
# cros-keyboard-map
excepts="$excepts etc/keyd"
# libinput
excepts="$excepts etc/libinput"
# lightdm
excepts="$excepts etc/lightdm"
# mce (Glacier / Asteroid)
excepts="$excepts etc/mce"
# mobile-config-thunderbird
excepts="
	$excepts
	etc/mobile-config-thunderbird
	etc/thunderbird
"
# mpv
excepts="$excepts etc/mpv"
# os-installer
excepts="$excepts etc/os-installer"
# Phosh
excepts="$excepts etc/phosh"
# pm-utils
excepts="$excepts etc/pm/config.d"
# samsungipcd (PPP)
excepts="$excepts etc/ppp"
# profile.d
excepts="$excepts etc/profile.d"
# pulseaudio
excepts="$excepts etc/pulse"
# pcscd
excepts="$excepts etc/reader.conf.d"
# sensorfw
excepts="$excepts etc/sensorfw"
# skel
excepts="$excepts etc/skel"
# ssh
excepts="$excepts etc/ssh/sshd_config.d"
# superd
excepts="$excepts etc/superd"
# sway
excepts="$excepts etc/sway etc/sway_hrdl"
# triggerhappy
excepts="$excepts etc/triggerhappy"
# usb-moded
excepts="$excepts etc/umtprd etc/usb-moded"
# usbguard
excepts="$excepts etc/usbguard"
# wpa_supplicant
excepts="$excepts etc/wpa_supplicant"
# xdg
excepts="$excepts etc/xdg"
# gesture
excepts="$excepts var/lib/gesture"
# polkit
excepts="$excepts var/lib/polkit-1"
# android-recovery-installer
excepts="$excepts var/lib/postmarketos-android-recovery-installer"
# shelli
excepts="$excepts var/lib/shelli var/spool"
# firmware
excepts="$excepts lib/firmware"
# kernel modules
excepts="$excepts lib/modules"

# Setup variables for returning
bad_files=""
exit_code=0

# Iterate over each package and check if the contents of those packages are in
# $bad_dirs
for package in $packages; do
	printf "Checking for invalid paths: %s\n" "$package"
	files="$(apk manifest --allow-untrusted "$package")"
	clean_files=""
	for path in $files; do
		case "$path" in
	    "sha"*)
	      ;;
	    *)
	      clean_files="$clean_files $path"
	      ;;
	  esac
	done
	for file in $clean_files; do
		for bad_dir in $bad_dirs; do
			# If a file's path is found to be in $bad_dir, add it to $bad_files for logging
			case "$file" in
				"$bad_dir"*)

					# If the file is an exception, ignore it
					for except in $excepts; do
						case "$file" in
							"$except"*)
								continue_bad_dir=1
								;;
						esac
					done
					if [ "$continue_bad_dir" = 1 ]; then
						continue;
					fi

					# :/ is just to make the logs a bit more readable
					bad_files="$bad_files $(basename "$package"):/$file"
					exit_code=1
					;;
			esac
		done
	done
done

# Finally, either print error logs with a list of files and their parent package or exit cleanly
if [ "$exit_code" != 0 ]; then
	printf "\nERROR: The following files should be installed under /usr/:\n" 1>&2
	for file in $bad_files; do
		printf "%s\n" "$file" 1>&2
	done
else
	printf "No invalid paths found.\n"
fi

exit "$exit_code"
