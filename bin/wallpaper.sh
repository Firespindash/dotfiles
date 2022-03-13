#!/bin/bash

cd ~/wallpaper
wal=$(zenity --file-selection --filename="~/wallpaper/leafs-improved.png" \
        --file-filter='Image files | *.png *.svg *.jpg *.jpeg')

[ "$wal" ] && dconf write /org/mate/desktop/background/picture-filename "'$wal'"
