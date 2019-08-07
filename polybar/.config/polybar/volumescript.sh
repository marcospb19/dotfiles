#!/usr/bin/sh

level=$(cat /sys/class/power_supply/BAT1/capacity)

[ $level -lt 97 ] && printf "$level%%"
