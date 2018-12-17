#!/usr/bin/env bash

mac-dns-clean(){
	sudo killall -HUP mDNSResponder
}

mac-clean(){
	sudo find ~ -name '.DS_Store' -print0 | xargs -0 rm
	sudo rm -rf $HOME/gpAdminLogs /cores/
	# 恢复:  defaults delete com.apple.desktopservices DSDontWriteNetworkStores
	# sudo defaults write com.apple.desktopservices DSDontWriteNetworkStores true
}

mac-reset-dock(){
	rm -r ~/Library/Application\ Support/Dock & killall Dock
}

mac-enable-search(){
	mdutil -s /Volumes/Backup

	sudo mdutil -i on /Volumes/Backup/

	# 清除索引
	# mdutil -E /Volumes/Backup/
	mdutil -s /Volumes/Backup
}

brew-forbidden(){
	# 在编译gpdb时, 如果使用它提供ar工具,编译失败
	brew remove binutils
}

brew-upgrade(){

	brew-forbidden

	brew update
	brew upgrade

	# Remove unused packages
	brew cleanup

	brew prune
	brew doctor
}

if_on_mac(){
	if [[ `uname -s` == 'Darwin' ]];then
		return 0
	else
		return 1
	fi
}
