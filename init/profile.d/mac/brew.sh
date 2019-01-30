#!/usr/bin/env bash
if [[ `uname -s` == 'Darwin' ]];then
	if [[ -f $(brew --prefix)/etc/bash_completion ]]; then
		. $(brew --prefix)/etc/bash_completion
	fi
fi

brew-switch-aliyun(){
	echo "so bad source! ignore it!"
	return

	local cur_dir=`pwd`

	cd "$(brew --repo)"
	git remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git

	cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
	git remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git

	brew update

	cat ~/.env| grep -v 'HOMEBREW_BOTTLE_DOMAIN' > ${HOME}/tmp/env_tmp
	mv ${HOME}/tmp/env_tmp ${HOME}/.env
	echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.env

	source "${HOME}/.env"

	cd ${cur_dir}
}

brew-switch-ustc(){
	local cur_dir=`pwd`

	cd "$(brew --repo)"
	git remote set-url origin https://mirrors.ustc.edu.cn/brew.git

	cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
	git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

	cd "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask
	git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git

	brew update

	cat ~/.env| grep -v 'HOMEBREW_BOTTLE_DOMAIN' > ${HOME}/tmp/env_tmp
	mv ${HOME}/tmp/env_tmp ${HOME}/.env
	echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.env

	source "${HOME}/.env"

	cd ${cur_dir}
}

brew-switch-tuna(){
	local cur_dir=`pwd`

	cd "$(brew --repo)"
	git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

	cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
	git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

	brew update

	cat ~/.env| grep -v 'HOMEBREW_BOTTLE_DOMAIN' > ${HOME}/tmp/env_tmp
	mv ${HOME}/tmp/env_tmp ${HOME}/.env
	echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.env

	source "${HOME}/.env"

	cd ${cur_dir}
}

brew-switch-back(){
	local cur_dir=`pwd`

	cd "$(brew --repo)"
	git remote set-url origin https://github.com/Homebrew/brew.git

	cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
	git remote set-url origin https://github.com/Homebrew/homebrew-core.git

	cd "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask
	git remote set-url origin https://github.com/Homebrew/homebrew-cask

	cat ~/.env| grep -v 'HOMEBREW_BOTTLE_DOMAIN' > ${HOME}/tmp/env_tmp
	mv ${HOME}/tmp/env_tmp ${HOME}/.env

	unset HOMEBREW_BOTTLE_DOMAIN
	source ${HOME}/.env

	cd ${cur_dir}
}

brew-forbidden(){
	# 在编译gpdb时, 如果使用它提供ar工具,编译失败
	brew remove binutils
}

brew-upgrade(){
	local cur_dir=`pwd`

	cd ${HOME}
	brew-forbidden

	brew update && brew upgrade

	# Remove unused packages
	brew cleanup

	brew bundle dump
	brew bundle --force cleanup

	# brew prune, 已过时, 现在由cleanup支持
	brew doctor

	[[ -f "./Brewfile" ]] && rm -f ./Brewfile

	cd ${cur_dir}
}