if [ "$(pamixer --get-volume-human)" = 'muted' ]; then
    echo '  muted  '
else
    echo
fi
