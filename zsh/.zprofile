# Default applications
export EDITOR=nvim
export BROWSER=google-chrome

# Set terminal tabs width
tabs -4

if [ ! "$DISPLAY" ] && [ "$(tty)" = '/dev/tty1' ]; then
	startx /usr/bin/i3 2>&1 > /dev/null
fi
