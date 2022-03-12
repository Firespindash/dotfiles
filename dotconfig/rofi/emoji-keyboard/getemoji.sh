#!/bin/bash

dir="/home/$USER/.config/rofi/emoji-keyboard"

emoji=$(rofi -i -dmenu -p Emoji: -theme $dir/emoji.rasi \
  -hover-select -me-select-entry 'MouseSecondary' -me-accept-entry 'MousePrimary' < $dir/emojilist.txt)

[ -z "$emoji" ] && exit

sleep 0.2
xclip -selection clipboard -rmlastnl <<< "$emoji"
xdotool type --clearmodifiers "$emoji"