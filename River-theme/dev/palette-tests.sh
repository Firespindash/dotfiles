#!/bin/sh

# From: https://stackoverflow.com/questions/26889358/generate-color-palette-from-image-with-imagemagick
# Thanks to Kurt Pfeifle

convert pastel.jpg -format %c -colorspace LAB -colors 5 histogram:info:-
convert -size 60x60 label:"  PaletteTest" xc:"srgb(8.8067%,69.041%,58.1544%)" xc:"srgb(27.4974%,56.5706%,46.9583%)" xc:"srgb(28.1885%,71.229%,62.2236%)" xc:"srgb(30.5301%,35.6791%,41.1788%)" xc:"srgb(39.8907%,36.8755%,58.1715%)" \
 +append test-palette.jpg

convert pastel.jpg -format %c -colorspace LAB -colors 16 histogram:info:-
convert pastel.jpg -format %c -colorspace LAB -colors 16 histogram:info:- | cut -d '#' -f 2- | cut -d ' ' -f 2
convert -size 60x60 label:"  PaletteTest" xc:"srgb(8.8067%,69.041%,58.1544%)" xc:"srgb(27.4974%,56.5706%,46.9583%)" xc:"srgb(28.1885%,71.229%,62.2236%)" xc:"srgb(30.5301%,35.6791%,41.1788%)" xc:"srgb(39.8907%,36.8755%,58.1715%)" xc:"srgb(59.6792%,42.9491%,63.8962%)" xc:"srgb(61.3452%,38.0911%,41.5021%)" xc:"srgb(65.2013%,64.5704%,64.6472%)" xc:"srgb(86.0872%,75.7451%,30.4971%)" xc:"srgb(92.3843%,43.9917%,53.3758%)" xc:"srgb(93.1798%,38.8753%,44.7275%)" xc:"srgb(95.1826%,61.5018%,59.9849%)" xc:"srgb(95.2027%,81.8378%,65.4148%)" xc:"srgb(95.6187%,81.3214%,31.9241%)" xc:"srgb(95.7203%,59.8839%,36.7065%)" xc:"srgb(97.1841%,58.0226%,40.7686%)" +append testpalette2.jpg
convert \
 test-palette.jpg \
 testpalette2.jpg  \
 -append \
 color-palettes.jpg

mv color-palettes.jpg river-palette.jpg
