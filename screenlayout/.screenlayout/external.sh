#!/bin/sh

source ~/.screenlayout/settings.sh

xrandr \
	--output $external_display --mode $external_display_resolution --refresh 300
