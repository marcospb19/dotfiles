# Default applications
export EDITOR=nvim
export BROWSER=firefox-developer-edition

# Set terminal tabs width
tabs -4

if [ ! "$DISPLAY" ] && [ "$(tty)" = '/dev/tty1' ]; then
	startx &> /dev/null
fi
