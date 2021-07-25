#!/bin/bash
# Function with a bit of changes from original to set repeated assets quickly
# Pass the name as first argument and the mold name as second argument
topng() {
	name=$1
	mold=$2
	inkscape ../gtk2-svgs/$mold-mold.svg -o assets/$name.png
	inkscape ../gtk2-svgs/$mold-mold.svg -o assets/$name-prelight.png
	inkscape ../gtk2-svgs/$mold-mold.svg -o assets/$name-insens.png
}
# Inkscape magic
inkscape ../gtk2-svgs/tab-matrix.svg -o assets/tab-bottom-active.png > /dev/null