#!/bin/sh
xrandr \
	--output eDP-1 --primary --mode 1366x768 \
	--output HDMI-1 --off \
	--output DP-1 --off
