#!/bin/bash

# Usage: ./download.sh PATH 

# TIP: Use this to create a more updated emoji list or your own list
# To do this use the script, open the file downloaded in 
# a text editor, like gedit, and go deleting the characters 
# that doesn't appear and you may have a new list of emojis
# with some new emojis there

# The default emoji list is on version 13.0, but it is already
# good for me. I decided to not run this every time getemoji.sh
# is used, because it is more stable and runs better without it

[ -d "$1" ] && path="$1" && [ -f $path/emojis-v* ] || { echo "Invalid path."; exit; }

version=$(basename $path/emojis-v* | cut -d '_' -f 2)
new=$((version + 1))

check=$(curl --head --silent https://unicode.org/Public/emoji/${new}.0/emoji-test.txt)

if ! echo "$check" | grep -q 404
then
	echo "Updating emoji list..."
	curl https://unicode.org/Public/emoji/${new}.0/emoji-test.txt -o $path/emojis-v_${new}_.txt
	emojis=$(grep "class='chars'" $path/emojis-v_${new}_.txt | cut -d '>' -f 2 | cut -d '<' -f)

	echo "$emojis" > $path/emojis-v_${new}_.txt
	rm $path/emojis-v_${version}_.txt
fi
