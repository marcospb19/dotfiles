#!/bin/sh
xrandr \
	--output eDP-1 --primary --mode 1366x768 \
	--output HDMI-1 --mode 2560x1080 --pos 1366x0 \
	--output DP-1 --off
