#!/bin/sh

source ~/.screenlayout/settings.sh

xrandr \
	--output $notebook_display --off \
	--output $external_display --mode $external_display_resolution --refresh 74.99 
