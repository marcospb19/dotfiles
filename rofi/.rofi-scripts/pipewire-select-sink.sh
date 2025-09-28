sinks=$(wpctl status | grep "Sinks" -A 100 | tail -n +2 | sed '/Sources/ q' | head -n -2)

# Remove leading symbols
sinks=$(echo "$sinks" | sed -E "s/^....(.)/ \1/g")

# Remove some distracting repetitive words
sinks=$(echo "$sinks" | sed -E "s/(Analog|Stereo|Digital|Audio|Controller) //g")

selected=$(echo "$sinks" | rofi -dmenu -i -p "Select sink")

# If rofi was cancelled
if [ $? -ne 0 ]; then
    exit
fi

selected_sink_id=$(echo "$selected" | grep -oE "[[:digit:]]+" | head -n 1)

wpctl set-default $selected_sink_id
