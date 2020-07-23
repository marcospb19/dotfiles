#!/bin/bash

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.2; done

polybar -q HDMI &
sleep 0.15 # Making sure that the first runs first
polybar -q eDP &
