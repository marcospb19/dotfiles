output="$(pamixer --get-volume | tr -d '\n')%"

if [ "$(pamixer --get-volume-human)" = 'muted' ]; then
    output="${output} (muted)"
fi

echo $output
