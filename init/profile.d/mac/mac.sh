#!/usr/bin/env bash

mac-dns-clean(){
	sudo killall -HUP mDNSResponder
}

mac-clean(){
	sudo find ~ -name '.DS_Store' -print0 | xargs -0 rm
	sudo rm -rf ${HOME}/gpAdminLogs /cores/
	# 恢复:  defaults delete com.apple.desktopservices DSDontWriteNetworkStores
	# sudo defaults write com.apple.desktopservices DSDontWriteNetworkStores true
}

mac-reset-dock(){
	rm -r ~/Library/Application\ Support/Dock & killall Dock
}

mac-reset-safari(){
	rm -rf "${HOME}/Library/Caches/com.apple.Safari"
	rm -rf "${HOME}/Library/Caches/com.apple.Safari.SafeBrowsing/"

	rm -rf "${HOME}/Library/Safari/History.db*"
	rm -rf "${HOME}/Library/Safari/HistoryIndex.sk"
	rm -rf "${HOME}/Library/Safari/LastSession.plist"
	rm -rf "${HOME}/Library/Safari/RecentlyClosedTabs.plist"
	rm -rf "${HOME}/Library/Saved Application State"
	echo "酌情考虑删除 ~/Library/Internet Plug-Ins/"
}

mac-enable-search(){
	mdutil -s /Volumes/Backup

	sudo mdutil -i on /Volumes/Backup/

	# 清除索引
	# mdutil -E /Volumes/Backup/
	mdutil -s /Volumes/Backup
}

mac-show-hidden-file(){
	defaults write com.apple.finder AppleShowAllFiles -bool true
	echo "请手动重启finder"
}

mac-show-common-file(){
	defaults write com.apple.finder AppleShowAllFiles -bool false
	echo "请手动重启finder"
}
