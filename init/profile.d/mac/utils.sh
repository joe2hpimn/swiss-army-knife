#!/usr/bin/env bash

change-shell(){
	local name=$1
	echo "changing to $name"
	chsh -s `which ${name}`
	echo "done"
}

privoxy-start(){
	nohup privoxy ${OPT}/privoxy/config > /dev/null 2>&1 &
}

jls(){
	killall IntelliJIDEALicenseServer_darwin_amd64
	nohup ${OPT}/crack/jls/IntelliJIDEALicenseServer_darwin_amd64 -l 127.0.0.1 -p 1024 -prolongationPeriod 607875500 -u baotingfang >/dev/null 2>&1 &
}

vmware-update-vmmon(){
	# sudo rm -rf /System/Library/Extensions/vmmon.kext
	# sudo cp -pR /Applications/VMware\ Fusion.app/Contents/Library/kexts/vmmon.kext /System/Library/Extensions/
	# sudo kextunload /System/Library/Extensions/vmmon.kext
	# sudo kextutil /System/Library/Extensions/vmmon.kext
	echo "done"
}

# 快速显示二维码
qr(){
	test -s $1 && echo "Usage: qr URL" && return
	qrencode -t ASCIIi $1
}

qr-wiki(){
	qr http://192.168.0.110:8888/pages
}

convert-to-mp4()
{
	# brew install ffmpeg
	# Mac上录制视屏使用: shift+command+5
	file=${1:-noname}

	[[ ! -f ./${file} ]] && echo "can not find ${file}" && return

	name=${file%.*}
	output_name="${name}.mp4"

	ffmpeg -i ${file} ${output_name}
}
