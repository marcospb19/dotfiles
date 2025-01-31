# Default applications
export EDITOR=nvim
export BROWSER=google-chrome-stable

# Dark mode, gtk and qt
# run `yay -S gnome-themes-extra adwaita-qt5-git adwaita-qt6-git` first
export GTK_THEME=Adwaita:dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=Adwaita-Dark
# export XDG_CURRENT_DESKTOP=KDE
export ZED_DEVELOPMENT_AUTH=1

# Set terminal tabs width
tabs -4

if [ ! "$DISPLAY" ] && [ "$(tty)" = '/dev/tty1' ]; then
	startx /usr/bin/i3 2>&1 > /dev/null
fi

CARGO_ENV="$HOME/.cargo/env"
[ -f $CARGO_ENV ] && source $CARGO_ENV
