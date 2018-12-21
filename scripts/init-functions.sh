#!/usr/bin/env bash

# CUR_DIR=$(cd `dirname ${BASH_SOURCE[0]}`; pwd)
# BASE_DIR=$(cd `dirname $CUR_DIR`; pwd)

BASE_DIR="$HOME/bin"
CONF_DIR="$BASE_DIR/config"

init_dirs(){
	local cur_dir=`pwd`

	cd $HOME
	mkdir go-projects \
		tmp \
		opt \
		workspace \
		tools \
		projects \
		github \
		Pivotal \
		share_bak \
		wiki

	cd ${cur_dir}
}

install-platform-package(){
	local cur_dir=`pwd`
	local dist_name=`get_os_name`

	case ${dist_name} in
		darwin)
			install-brew-packages
			;;
		ubuntu)
			install-ubuntu-packages
			;;
		centos)
			install-centos-packages
			;;
		*)
			green -e "Not Support $dist_name System"
			;;
	esac

	# install vim plugins
	test -d $HOME/.vim && mv $HOME/.vim $HOME/.vimbackup
	git clone http://github.com/luan/vimfiles.git $HOME/.vim

	$HOME/.vim/install

	cd ${cur_dir}
}

install-brew-packages(){
	local cur_dir=`pwd`

	cd ${BASE_DIR}
	green "Install Mac Packages..."
	brew install vim --with-lua --with-python
	cat ./taps | xargs brew tap
	cat ./packages | xargs brew install

	cd ${cur_dir}
}

install-ubuntu-packages(){
	local cur_dir=`pwd`

	green "Install Ubuntu Packages..."
	sudo apt update
	sudo apt install -y vim zsh \
		golang python-pip python3-pip \
		nodejs direnv

	cd ${cur_dir}
}

install-centos-packages(){
	local cur_dir=`pwd`

	green "Install CentOS Packages..."

	cd ${cur_dir}
}

create-links(){
	local cur_dir=`pwd`

	for i in $(ls ${CONF_DIR});
	do
		target="$CONF_DIR/$i"
		echo "$target"
		[[ -f ${target} ]] && ln -sf "$target" "$HOME/.$i" && echo "$i linked!"
	done

	rm -f $HOME/.vim/my-UltiSnips || true
	ln -s ${CONF_DIR}/UltiSnips ${HOME}/.vim/my-UltiSnips && echo "UltiSnips linked!"
	ln -s ${CONF_DIR}/gpdb/config ${HOME}/opt/data/ && echo "gpdb config linked!"
	ln -s ${CONF_DIR}/zsh/plugins/* ${HOME}/.oh-my-zsh/custom/plugins/ && echo "custom zsh-plugins config linked!"
	ln -s ${CONF_DIR}/zsh/themes/* ${HOME}/.oh-my-zsh/custom/themes/ && echo "custom zsh-themes config linked!"

	ln -s ${CONF_DIR}/dnsmasq ${OPT}/ && echo "custom dnsmasq config linked!"
	cp ${CONF_DIR}/dnsmasq/dnsmasq.conf /usr/local/etc/dnsmasq.conf && echo "copied dnsmasq.conf to /usr/local/etc/dnsmasq"

	mkdir -p $HOME/tmp || true
	ln -s ${BASE_DIR}/tmp/bin $HOME/tmp/ && echo "tmp tools linked!"

	if [[ -h $HOME/.tmux ]];then
		rm -rf $HOME/.tmux
	fi
	ln -s ${CONF_DIR}/tmux ${HOME}/.tmux && echo "tmux config linked!"

	# start a new era
	source $HOME/.zshrc

	cd ${cur_dir}
}

install-go-packages(){
	local cur_dir=`pwd`

	green "Install Go Packages..."

	cd ${BASE_DIR}
	GOPATH="$HOME/go-projects"
	GOBIN="$GOPATH/bin"
	go env

	mkdir -p "$GOPATH/{bin,pkg,src}" || true

	for package in `cat "$BASE_DIR/go-packages"`
	do
		echo "Installing: $package"
		go get -u "$package"

		if [[ $? == 0 ]]; then
			echo "Installed: $package successfully!"
		else
			echo "Installed: $package failed!"
		fi
	done

	cd ${cur_dir}
}

install-python-packages(){
	local cur_dir=`pwd`

	green "Install Python Packages..."

	cd ${BASE_DIR}

	pip install --upgrade pip virtualenv virtualenvwrapper
	pip3 install --upgrade pip virtualenv virtualenvwrapper neovim

	PYCURL_SSL_LIBRARY=openssl pip install pycurl

	pip install -r python-packages

	cd ${cur_dir}
}


