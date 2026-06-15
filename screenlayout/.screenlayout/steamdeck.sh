#!/bin/sh

set -x
source ~/.screenlayout/settings.sh

xrandr --newmode "1280x800_60.00" 83.50 1280 1352 1480 1680 800 803 809 831 -hsync +vsync
xrandr --addmode $external_display "1280x800_60.00"

xrandr \
	--output $external_display --mode 1280x800_60.00
set +x
