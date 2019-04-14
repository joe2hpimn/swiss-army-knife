#!/usr/bin/env bash

cmd-external-ip(){
	curl ifconfig.me
}

cmd-my-disk(){
	mount | column -t
}

cmd-show-ascii(){
	man ascii
}

cmd-download-the-whole-website(){
	local URL=$1
	wget --random-wait -r -p -e robots=off -U mozilla "${URL}"
}

cmd-show-star-wars(){
	telnet towel.blinkenlights.nl
}

cmd-often-commands(){
	history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

cmd-unique-lines(){
	awk '!x[$0]++' $1
}
