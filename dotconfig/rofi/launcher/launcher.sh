#!/bin/bash
dir='~/.config/rofi/launcher'
rofi -no-lazy-grab -show drun -modi drun -theme $dir/launcher.rasi -hover-select -me-select-entry '' -me-accept-entry 'MousePrimary' -kb-cancel 'Alt+F1,Escape'
