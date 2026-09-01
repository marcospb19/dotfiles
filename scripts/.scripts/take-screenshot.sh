rm /tmp/screenshot.png 2> /dev/null

scrot -s /tmp/screenshot.png && xclip -selection clipboard -t image/png -i /tmp/screenshot.png
