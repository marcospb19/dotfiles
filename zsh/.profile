# Default applications
export EDITOR=nvim
export BROWSER=chromium

# Set terminal tabs width
tabs -4

# if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
if [ ! $DISPLAY ] && [ $(tty) = "/dev/tty1" ]; then
	startx /usr/bin/i3 2> /dev/null > /dev/null
fi
source "$HOME/.cargo/env"

export PATH="$HOME/.poetry/bin:$PATH"
