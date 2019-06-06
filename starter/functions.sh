#!/usr/bin/env bash
#shellcheck disable=2155,2164,2045,2034

hello() {
  echo "Baotingfang, It's me, 鲍亭方"
}

green(){
	echo -e "\033[32m ${1:-''} \033[0m"
}

red(){
	echo -e "\033[31m ${1:-''} \033[0m"
}

yellow(){
	echo -e "\033[33m ${1:-''} \033[0m"
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
	local os_name="$(python -c 'import platform; print platform.system()')"

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
			green "Not Support ${dist_name} System"
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

	LN_OPTS='-n'

	if-on-mac && LN_OPTS='-h'

	for i in $(ls ${CONF_DIR});
	do
		target="$CONF_DIR/$i"
		echo "$target"
		[[ -f ${target} ]] && ln -sf ${LN_OPTS} "$target" "${HOME}/.$i" && echo "$i 成功创建软链!"
	done


	ln -sf ${LN_OPTS} ${CONF_DIR}/UltiSnips ${HOME}/.vim/my-UltiSnips && echo "UltiSnips 成功创建软链!"
	ln -sf ${LN_OPTS} ${CONF_DIR}/gpdb/config ${HOME}/opt/data/ && echo "gpdb config 成功创建软链!"

	for i in $(ls ${CONF_DIR}/zsh/plugins/);
	do
		target="${CONF_DIR}/zsh/plugins/$i"
		[[ -d ${target} ]] && ln -sf ${LN_OPTS} "$target" "${HOME}/.oh-my-zsh/custom/plugins/$i" && echo "$i 成功创建软链!"
	done


	for i in $(ls ${CONF_DIR}/zsh/themes/);
	do
		target="${CONF_DIR}/zsh/themes/$i"
		[[ -f ${target} ]] && ln -sf ${LN_OPTS} "$target" "${HOME}/.oh-my-zsh/custom/themes/$i" && echo "$i 成功创建软链!"
	done

#	ln -sf ${LN_OPTS} ${CONF_DIR}/zsh/plugins/opengit ${HOME}/.oh-my-zsh/custom/plugins/opengit
#	ln -sf ${LN_OPTS} ${CONF_DIR}/zsh/plugins/vim-func ${HOME}/.oh-my-zsh/custom/plugins/vim-func
#	ln -sf ${LN_OPTS} ${CONF_DIR}/zsh/themes/my.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/my.zsh-theme

	ln -sf ${LN_OPTS} ${CONF_DIR}/dnsmasq ${OPT}/ && echo "自定义dnsmasq配置文件 成功创建软链!"
	ln -sf ${LN_OPTS} ${CONF_DIR}/tmux ${HOME}/.tmux && echo "tmux配置文件 成功创建软链!"

	if-on-mac && cp ${CONF_DIR}/dnsmasq/dnsmasq.conf /usr/local/etc/dnsmasq.conf && echo "复制dnsmasq.conf 到 /usr/local/etc/dnsmasq"

	ln -sf ${LN_OPTS} ${BASE_DIR}/tmp/bin ${HOME}/tmp/ && echo "tmp/bin工具箱 成功创建软链!"

	cd ${cur_dir}
}

install-go-packages(){
	local cur_dir=`pwd`

	yellow "安装Go软件包..."

	cd ${STARTER_DIR}

	GOPATH="${HOME}/go-projects"
	GOBIN="${GOPATH}/bin"
	go env

	for package in `cat "./go-packages"`
	do
		go get -u "$package" && green "成功安装: $package" || red "安装失败: $package"
	done

	cd ${cur_dir}
}

install-python-packages(){
	local cur_dir=`pwd`

	yellow "安装Python软件包..."

	cd ${STARTER_DIR}

	pip install --upgrade pip virtualenv virtualenvwrapper
	pip3 install --upgrade pip virtualenv virtualenvwrapper neovim
	PYCURL_SSL_LIBRARY=openssl pip install --user pycurl

	pip install --user -r ./python-packages

	cd ${cur_dir}
}

install-node-packages(){
	local cur_dir=`pwd`

	yellow "安装NodeJs软件包..."

	cd ${STARTER_DIR}

	for package in `cat "./node-packages"`
	do
		npm install -g "$package" && green "成功安装: $package" || red "安装失败: $package"
	done

	cd ${cur_dir}
}


