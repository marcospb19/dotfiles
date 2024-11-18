# Default applications
export EDITOR=nvim
export BROWSER=google-chrome-stable

# Dark mode, gtk and qt
# run `yay -S gnome-themes-extra adwaita-qt5-git adwaita-qt6-git` first
GTK_THEME=Adwaita:dark
GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
QT_STYLE_OVERRIDE=Adwaita-Dark

# Set terminal tabs width
tabs -4

if [ ! "$DISPLAY" ] && [ "$(tty)" = '/dev/tty1' ]; then
	startx /usr/bin/i3 2>&1 > /dev/null
fi

CARGO_ENV="$HOME/.cargo/env"
[ -f $CARGO_ENV ] && source $CARGO_ENV
