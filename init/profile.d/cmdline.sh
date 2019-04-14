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

cmd-local-smtp-server(){
	python -m smtpd -n -c DebuggingServer localhost:1025
}


?(){
	echo "$*" | bc -l;
}

cmd-hijack-stdout(){
	local pid=$1
	strace -ff -e trace=write -e write=1,2 -p ${PID}
}

cmd-find(){
	# 递归查找当前目录下所有文件
	local pattern=$1
	grep -RnisI ${pattern} *
}

cmd-biggest-files(){
	du -s * | sort -n | tail
}

cmd-bash-colors(){
	for code in {0..255}; do echo -e "\e[38;05;${code}m $code: Test"; done
}

cmd-I-AM-BUSY(){
	cat /dev/urandom | hexdump -C | grep "ca fe"
}
