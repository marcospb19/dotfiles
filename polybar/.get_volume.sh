pactl get-sink-volume @DEFAULT_SINK@ | rg -o "\d+%" | head -1
