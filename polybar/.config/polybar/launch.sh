#!/bin/bash

killall -q polybar
pkill polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep '0.1'; done

polybar -q HDMI &
# sleep 0.15 # Making sure that the first runs first
# polybar -q eDP &
