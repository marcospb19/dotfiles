#!/bin/sh

source ~/.screenlayout/settings.sh

xrandr \
	--output $notebook_display --primary --mode $notebook_display_resolution \
	--output $external_display --off
