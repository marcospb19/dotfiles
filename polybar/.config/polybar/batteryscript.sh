level=$(cat /sys/class/power_supply/BAT1/capacity)
[ "${level}" -le 90 ] && printf "${level}%%"
