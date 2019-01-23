#!/usr/bin/env bash

hello() {
  echo baotingfang is here!
}

green(){
	echo -e "\033[32m ${1:-''} \033[0m"
}

if-on-mac(){
	if [[ `uname -s` == 'Darwin' ]];then
		return 0
	else
		return 1
	fi
}

get-os-name(){
	# centos, darwin, ubuntu
	local os_name=`python -c "import platform; print platform.system()"`

	if [[ ${os_name} == 'Darwin' ]];then
		name=`python -c "print '${os_name}'.lower()"`
	else
		name=`python -c "import platform; print platform.dist()[0].lower()"`
	fi

	if [[ ${name} == 'elementary' ]];then
		echo "ubuntu"
	else
		echo "${name}"
	fi
}

get-os(){
	# linux, darwin, ....
	python -c "import platform; print platform.system().lower()"
}

create-dirs(){
	local cur_dir=`pwd`

	cd ${HOME}

	mkdir -p go-projects/bin \
		go-projects/pkg \
		go-projects/src \
		tmp \
		opt/Cells \
		opt/gpdb \
		opt/gpdb4 \
		opt/data/gpdb \
		opt/data/gpdb4 \
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
	local dist_name=`get-os-name`

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
	test -d ${HOME}/.vim && mv ${HOME}/.vim ${HOME}/.vimbackup
	git clone http://github.com/luan/vimfiles.git ${HOME}/.vim

	${HOME}/.vim/install

	cd ${cur_dir}
}

install-brew-packages(){
	local cur_dir=`pwd`

	cd ${STARTER_DIR}
	green "Install Mac Packages..."

	brew install vim --with-lua --with-python
	cat ./brew-taps | xargs brew tap
	cat ./brew-packages | xargs brew install

	cd ${cur_dir}
}

install-ubuntu-packages(){
	local cur_dir=`pwd`

	cd ${STARTER_DIR}

	green "Install Ubuntu Packages..."

	sudo apt update
	sudo apt install -y vim \
			zsh \
			golang \
			python-pip python3-pip \
			nodejs \
			direnv \
			tmux \
			libzstd-dev

	cd ${cur_dir}
}

install-centos-packages(){
	local cur_dir=`pwd`

	cd ${STARTER_DIR}
	green "Install CentOS Packages..."

	cd ${cur_dir}
}

create-links(){
	local cur_dir=`pwd`

	for i in $(ls ${CONF_DIR});
	do
		target="$CONF_DIR/$i"
		echo "$target"
		[[ -f ${target} ]] && ln -sf "$target" "${HOME}/.$i" && echo "$i linked!"
	done

	LN_OPTS='-n'

	if-on-mac && LN_OPTS='-h'

	ln -sf ${LN_OPTS} ${CONF_DIR}/UltiSnips ${HOME}/.vim/my-UltiSnips && echo "UltiSnips linked!"
	ln -sf ${LN_OPTS} ${CONF_DIR}/gpdb/config ${HOME}/opt/data/ && echo "gpdb config linked!"

	ln -sf ${LN_OPTS} ${CONF_DIR}/zsh/plugins/opengit ${HOME}/.oh-my-zsh/custom/plugins/opengit
	ln -sf ${LN_OPTS} ${CONF_DIR}/zsh/plugins/vim-func ${HOME}/.oh-my-zsh/custom/plugins/vim-func
	ln -sf ${LN_OPTS} ${CONF_DIR}/zsh/themes/my.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/my.zsh-theme

	ln -sf ${LN_OPTS} ${CONF_DIR}/dnsmasq ${OPT}/ && echo "custom dnsmasq config linked!"
	ln -sf ${LN_OPTS} ${CONF_DIR}/tmux ${HOME}/.tmux && echo "tmux config linked!"

	if-on-mac && cp ${CONF_DIR}/dnsmasq/dnsmasq.conf /usr/local/etc/dnsmasq.conf && echo "copied dnsmasq.conf to /usr/local/etc/dnsmasq"

	ln -sf ${LN_OPTS} ${BASE_DIR}/tmp/bin ${HOME}/tmp/ && echo "tmp tools linked!"

	cd ${cur_dir}
}

install-go-packages(){
	local cur_dir=`pwd`

	green "Install Go Packages..."

	cd ${STARTER_DIR}

	GOPATH="${HOME}/go-projects"
	GOBIN="$GOPATH/bin"
	go env

	for package in `cat "./go-packages"`
	do
		go get -u "$package" && echo "Installed: $package successfully!" || echo "Installed: $package failed!"
	done

	cd ${cur_dir}
}

install-python-packages(){
	local cur_dir=`pwd`

	green "Install Python Packages..."

	cd ${STARTER_DIR}

	pip install --upgrade pip virtualenv virtualenvwrapper
	pip3 install --upgrade pip virtualenv virtualenvwrapper neovim
	PYCURL_SSL_LIBRARY=openssl pip install --user pycurl

	pip install --user -r ./python-packages

	cd ${cur_dir}
}

install-node-packages(){
	local cur_dir=`pwd`

	green "Install NodeJs Packages..."

	cd ${STARTER_DIR}

	for package in `cat "./node-packages"`
	do
		node install -g "$package" && echo "Installed: $package successfully!" || echo "Installed: $package failed!"
	done

	cd ${cur_dir}
}


