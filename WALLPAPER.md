# About wallpapers

This file contains the recipe for making an optimal wallpaper, from an image to a proper wallpaper. \
The formula used in the wallpapers from this repository. \
And the instructions regarding wallpapers, the country flag wallpapers, in this repository. \
Did you know you can add a country flag to this repository!? See the rules below at the bottom of this file, before opening a pull request.

TL;DR: Just add a vignette effect in the wallpaper, without affecting the up-center region.

## About the Recipe
To create an improved wallpaper, you could use any image editor, but in _GIMP_ it is just really fast. Follow the formula below you will have an improved version of the wallpaper, it can be considered improved because it increases the readability fitting better into the desktop ecosystem than an unprepared image. These effects are obtain by the usage of a radial gradient mask, or anything that can simulate a vignette effect on the image, with a dark color on top of the image, a simple process that brings significant benefits.
## Wallpaper Creation Recipe
You can import the image you want as a layer inside the **wallpaper/dev/wallpaper-improvement-recipe.xcf** file and just put it above the bottom layer with the most recent wallpaper image.

Or
for more customization, you can open the image in the editor, \
add a layer on top, \
fill it with a desired dark color, give preference for grays and browns or colors matching the color scheme and the image at the same time if possible, \
then create a new opacity mask. \
After that, just grab the radial gradient tool, \
then create a circle the size you want, \
set the starting point to a transparent value while the ending point as the opaque color you chose. \
Ideally, the up-center of the image should stay as the original image, without being affected by the mask. 

A mixture of both ways do work too, for instance, in this repository most wallpapers were created by changing the color of the layer above the image.

## About adding country flags
Feel free to add your country flag; but in order for it to be accepted to the repository, the rules are:
- It has to be a concrete wall version of the flag, it fits better as an wallpaper;
- It needs to use the improvement formula described above;
- It has to be a recognized country flag, a UN member state flag, so the flag from Cyprus is valid and the one from Taiwan is not but this does not exclude associated special territories like HK and Greenland;
- Only country flags, storing city or state/province flags here would be harder and messy.


