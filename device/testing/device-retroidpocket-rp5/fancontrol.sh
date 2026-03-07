#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)
# Adapted for postmarketOS

# Find PWM fan device
FAN_PWM=$(ls /sys/class/hwmon/hwmon*/pwm1 2>/dev/null | head -1)

if [ -z "$FAN_PWM" ]; then
    echo "No PWM fan found"
    exit 1
fi

FAN_ENABLE="${FAN_PWM}_enable"

# Temperature thresholds (millicelsius)
MAXTEMP=75000
HIGHTEMP=65000
MIDTEMP=55000
LOWTEMP=45000
MINTEMP=35000

# Find CPU thermal zone
TEMP_SENSOR=""
for tz in /sys/class/thermal/thermal_zone*/temp; do
    name=$(cat "$(dirname "$tz")/type" 2>/dev/null)
    case "$name" in
        cpu*|CPU*) TEMP_SENSOR="$tz"; break ;;
    esac
done

if [ -z "$TEMP_SENSOR" ]; then
    TEMP_SENSOR="/sys/class/thermal/thermal_zone0/temp"
fi

set_control() {
    if [ -e "$FAN_ENABLE" ]; then
        echo "$1" > "$FAN_ENABLE"
    fi
}

cleanup() {
    set_control 0
    exit 0
}

trap cleanup SIGHUP SIGINT SIGQUIT SIGABRT SIGTERM

echo "Fan control started: $FAN_PWM, sensor: $TEMP_SENSOR"
set_control 1

CTEMP=0

while true; do
    CPU_TEMP=$(cat "$TEMP_SENSOR" 2>/dev/null)

    if [ "$CPU_TEMP" -gt "$MAXTEMP" ]; then
        FSPEED=255
        TEMP=$MAXTEMP
    elif [ "$CPU_TEMP" -gt "$HIGHTEMP" ]; then
        FSPEED=196
        TEMP=$HIGHTEMP
    elif [ "$CPU_TEMP" -gt "$MIDTEMP" ]; then
        FSPEED=128
        TEMP=$MIDTEMP
    elif [ "$CPU_TEMP" -gt "$LOWTEMP" ]; then
        FSPEED=96
        TEMP=$LOWTEMP
    elif [ "$CPU_TEMP" -gt "$MINTEMP" ]; then
        FSPEED=64
        TEMP=$MINTEMP
    else
        FSPEED=32
        TEMP=0
    fi

    if [ "$TEMP" != "$CTEMP" ]; then
        echo "$FSPEED" > "$FAN_PWM"
        CTEMP=$TEMP
    fi

    sleep 3
done
