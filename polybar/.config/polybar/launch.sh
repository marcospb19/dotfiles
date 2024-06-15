#!/bin/bash

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.05; done

polybar -q DisplayPort &
# polybar -q HDMI &
# sleep 0.15 # Making sure that the first runs first
# polybar -q eDP &
