#!/bin/bash
VER="2.0"
LAST_UPDATED="February 2, 2016"

# Keybinds
KILL="q"    # Quit out from termage
PREV="n"    # Go to the previous image
NEXT="o"    # Go to the next image
REDRAW="r"  # Redraw the current image

# Colours
BLACK="\033[0m\033[30m"
RED="\033[0m\033[31m"
GREEN="\033[0m\033[32m"
YELLOW="\033[0m\033[33m"
BLUE="\033[0m\033[34m"
MAGENTA="\033[0m\033[35m"
CYAN="\033[0m\033[36m"
WHITE="\033[0m\033[37m"

# Test the params for valid files.
IMG=0
FILE=()
k=0
echo -e "${WHITE}Loading selected files..."
for arg in "$@"; do
	if [[ `file -i "$arg" | grep image` ]]; then
		echo -e "$GREEN$arg"
		FILE[k]=$arg
		k=`expr $k + 1`
	else
		echo -e "$RED$arg"
	fi
done
echo -e "${WHITE}Loaded all files."

if [[ ${FILE[$IMG]} == "" ]]; then
	echo -e "${RED}Error: No valid files."
	exit
fi

# Begin Image display loop
while true; do
	FILENAME=${FILE[$IMG]}
	# display the image
	wiw --clear "$FILENAME"
	
	# Wait for and respond to key strokes
	if [ -t 0 ]; then stty -echo -icanon time 0 min 0; fi
	KEYPRESS=''
	while true; do
		read -rsp "" -n1 KEYPRESS
		case $KEYPRESS in 
			$KILL) # Kill termage
				exit;;
			$PREV) # Previous image (changes to deal with dual image)
				IMG=`expr $IMG - 1`
				break;;
			$NEXT) # Next image (changes to deal with dual image)
				IMG=`expr $IMG + 1`
				break;;
			$REDRAW) # redraws the current image 
				break;;
			*);; 
		esac
	done
	IMG=`expr $IMG % ${#FILE[@]}`
done
