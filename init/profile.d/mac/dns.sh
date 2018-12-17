#!/usr/bin/env bash

dnsmasq-restart(){
	brew services restart dnsmasq
	mac-dns-clean
}

dns-home(){
	echo "nameserver 192.168.0.1" > "$OPT/dnsmasq/resolv.conf"
	dnsmasq-restart
}

# 公司的2个wifi的dns都一样
dns-office(){
	echo "nameserver 10.34.41.10" > "$OPT/dnsmasq/resolv.conf"
	echo "nameserver 10.152.2.10" >> "$OPT/dnsmasq/resolv.conf"
	dnsmasq-restart
}

dns-aliyun(){
	echo "nameserver 223.5.5.5" > "$OPT/dnsmasq/resolv.conf"
	echo "nameserver 223.6.6.6" >> "$OPT/dnsmasq/resolv.conf"
	dnsmasq-restart
}

dns-google(){
	echo "nameserver 8.8.8.8" > "$OPT/dnsmasq/resolv.conf"
	echo "nameserver 8.8.4.4" >> "$OPT/dnsmasq/resolv.conf"
	dnsmasq-restart
}

dns-114(){
	echo "nameserver 114.114.114.114" > "$OPT/dnsmasq/resolv.conf"
	echo "nameserver 1.2.4.8" >> "$OPT/dnsmasq/resolv.conf"
	dnsmasq-restart
}

dns-resolv(){
	cat "$OPT/dnsmasq/resolv.conf"
	echo "如果有需要， 请同步$HOME/opt/dnsmasq/hosts文件到本机的/etc/hosts, 请慎重操作"
}