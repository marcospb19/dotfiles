# Default applications
export EDITOR=nvim
export BROWSER=google-chrome-stable

# Dark mode, gtk and qt
# run `yay -S gnome-themes-extra adwaita-qt5-git adwaita-qt6-git` first
export GTK_THEME=Adwaita:dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=Adwaita-Dark
export ZED_DEVELOPMENT_AUTH=1
export GOPATH=$HOME/.go

tabs -4 # Terminal tabs width

PATH_CANDIDATES=(
    ".cargo/bin"
    ".local/bin"
    ".bin"
)

for CANDIDATE in $PATH_CANDIDATES; do
    if [ -d "$HOME/$CANDIDATE" ]; then
        export PATH=$HOME/$CANDIDATE:$PATH
    fi
done

if [ ! "$DISPLAY" ] && [ "$(tty)" = '/dev/tty1' ]; then
    startx /usr/bin/i3 2>&1 > /dev/null
fi

[ -f ~/.aliases ]   && . ~/.aliases
[ -f ~/.functions ] && . ~/.functions
