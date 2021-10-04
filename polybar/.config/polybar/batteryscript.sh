level=$(cat /sys/class/power_supply/BAT1/capacity)
[ "${level}" -le 25 ] && printf "Low battery: ${level}%%" || ( [ "${level}" -le 95 ] && printf "${level}%%" )
