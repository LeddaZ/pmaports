#!/bin/busybox ash
setup_joined_partitions() {
	if [ -e "/dev/mapper/joined-partitions" ] || [ "$1" = "" ]; then
		return
	fi

	table=""
	offset=0

	# Splitting is intentional
	# shellcheck disable=SC2068
	for dev in $@; do
		sectors=$(blockdev --getsz "$dev")

		table="$table$offset $sectors linear $dev 0"$'\n'
	    offset=$((offset + sectors))
	done

	printf '%s' "$table" | dmsetup create joined-partitions
}
