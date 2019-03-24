#!/usr/bin/env bash

# GPDB Demo cluster tools

gpdb-make-demo-cluster(){
	cur_dir=`pwd`
	cd ${WB}/gpdb/gpAux/gpdemo || return

	export MASTER_DATA_DIRECTORY=${WB}/gpdb/gpAux/gpdemo/datadirs/qddir/demoDataDir-1
	killall postgres || true

	make clean
	SHELL=/bin/bash make cluster

	cd ${cur_dir}
}

gpdb-clean-demo-cluster(){
	cur_dir=`pwd`
	cd ${WB}/gpdb/gpAux/gpdemo || return

	make clean

	cd ${cur_dir}
}

_gpdb-clean(){
	local cur_dir=`pwd`

	gpdb-env-set "$@"
	is_gpdb_src || return

	cd ${GPDB_SRC}

	# 1. try to clean the repo
	make clean || true

	# 2. clean the repo force
	read -p "will git clean the ${GPDB_SRC} repo continue?[y/n]?" choice

	if [[ ${choice} == 'y' ]];then
		git cl
		git-reset-submodules
	fi

	cd ${cur_dir}
}

gpdb-source-demo-cluster(){
	gpdb-env-set "$@"
	export MASTER_DATA_DIRECTORY=${WB}/gpdb/gpAux/gpdemo/datadirs/qddir/demoDataDir-1
}

# for dev tools
gpdb-cmakelists(){
  cat << "EOF" > CMakeLists.txt
cmake_minimum_required(VERSION 3.8)
project(gpdb)

set(CMAKE_CXX_STANDARD 11)

# add extra include directories
include_directories(src/include
	src/interfaces/libpq)

# add extra lib directories
# link_directories(/usr/local/lib)

# specify the dependency on an extra library
# target_link_libraries(hello_clion check.a)

file(GLOB_RECURSE SOURCE_FILES src *.c *.h *.cpp)

add_custom_target(build_gpdb COMMAND make -C ${gpdb_SOURCE_DIR}
												 CLION_EXE_DIR=${PROJECT_BINARY_DIR})


# specify the executable
add_executable(gpdb ${SOURCE_FILES})
EOF
}

gpdb-source(){
	gpdb-env-set "$@"

	MASTER_DATA_DIRECTORY="$GPDB_DATA_DIR/gpmaster/gpsne-1"

	if [[ -f ${GPDB_BIN}/greenplum_path.sh ]];then
		source ${GPDB_BIN}/greenplum_path.sh
	fi
}

gpdb-env-clear(){
	echo "一般自己调用，用于清理gpdb注册的环境变量，不要在脚本中随意调用..."

	unset GPHOME
	unset PYTHONPATH
	unset PYTHONHOME
	unset OPENSSL_CONF
	unset LD_LIBRARY_PATH
	unset DYLD_LIBRARY_PATH

	# !! 由用户指定 !!
	# unset GPDB_SRC
	unset GPDB_BIN
	unset GPDB_DATA_DIR
	unset INIT_CONFIG_NAME
	unset GPDB_KRB_KEYTAB
	unset MASTER_DATA_DIRECTORY
	echo "clear all gpdb env vars done!"
}

# 切换编译环境的关键环境变量
gpdb-env-set(){

	echo "usage: gpdb-env-set 5"
	gpdb-env-clear
	gpdb_target=${1:-"5"}


	echo "================================="
	echo "==== target gpdb version: $gpdb_target ====="
	echo "================================="

	export MASTER_HOSTNAME=`hostname`
	export GPDB_KRB_USER="kgpadmin/$MASTER_HOSTNAME"

	# !! GPDB_SRC 由外部程序指定 !!
	# 这是一个软链, 因此在编译之前要着重看一下链接的目标 对不对?
	# 默认值为 ${HOME}/workspace/gpdb
	export GPDB_SRC=${GPDB_SRC:-$WB/gpdb}

	if [[ ${gpdb_target} == '4' ]];then
		# export GPDB_SRC=${WB}/gpdb4
		export GPDB_BIN=${OPT}/gpdb4
		export GPDB_DATA_DIR=${OPT}/data/gpdb4
		export INIT_CONFIG_NAME=gpinitsystem_singlenode_4
		export GPDB_KRB_KEYTAB="${OPT}/data/config/gpdb4-krb.keytab"
	else
		export GPDB_BIN="${OPT}/gpdb"
		export GPDB_DATA_DIR="${OPT}/data/gpdb"
		export INIT_CONFIG_NAME=gpinitsystem_singlenode
		export GPDB_KRB_KEYTAB="${OPT}/data/config/gpdb-krb.keytab"
	fi

	export MASTER_DATA_DIRECTORY="$GPDB_DATA_DIR/gpmaster/gpsne-1"

	# The third lib
	# export LDFLAGS="-L/usr/local/opt/krb5/lib -L/usr/local/opt/openssl/lib -L/usr/local/opt/libxml2/lib"
	# export CPPFLAGS="-I/usr/local/opt/krb5/include -I/usr/local/opt/openssl/include -I/usr/local/opt/libxml2/include"

	echo "GPDB_SRC=$GPDB_SRC"
	echo "GPDB_BIN=$GPDB_BIN"
	echo "GPDB_DATA_DIR=$GPDB_DATA_DIR"
	echo "INIT_CONFIG_NAME=$INIT_CONFIG_NAME"
	echo "MASTER_DATA_DIRECTORY=$MASTER_DATA_DIRECTORY"
	echo "GPDB_KRB_KEYTAB=$GPDB_KRB_KEYTAB"
}

is_gpdb_src(){
	if [[ ! -d "${GPDB_SRC}/gpMgmt/" ]]; then
		echo "Please set the GPDB_SRC to an existed gpdb repo dir!"
		return 1
	fi

	return 0
}

gpdb-init(){
	locacl cur_dir=`pwd`

	mkdir -p "${OPT}/data/gpdb4/{gpdata,gpmaster}" || true
	mkdir -p "${OPT}/data/gpdb/{gpdata,gpmaster}" || true

	sudo cat "${OPT}/data/config/sysctl.conf" >> /etc/sysctl.conf

	cd ${WB} || return

	git clone git@github.com:greenplum-db/gpdb.git gpdb-dev || true
	git clone git@github.com:greenplum-db/gporca.git gporca || true
	git clone git@github.com:greenplum-db/gp-xerces.git gp-xerces || true
	git clone git@github.com:greenplum-db/gpos.git gpos || true
	cd ${cur_dir}
}

_gpdb-compile(){
	local cur_dir=`pwd`

	is_gpdb_src || return

	which gpstop >> /dev/null && gpstop -a || kill-postgres
	cd ${GPDB_SRC}

	# make ARCHFLAGS="-arch x86_64" && make install ARCHFLAGS="-arch x86_64"
	make -j8 && make install

	gpdb-source "$@"
	${GPDB_BIN}/bin/gpstart -a

	cd ${cur_dir}
}

_gpdb-full-compile(){
	local cur_dir=`pwd`
	local choice="n"

	gpdb-env-set "$@"

	is_gpdb_src || return

	which gpstop >> /dev/null && gpstop -a || kill-postgres
	read -p "will remove ${GPDB_BIN} continue?[y/n]?" choice

	if [[ ${choice} == 'y' ]];then
		rm -rf ${GPDB_BIN} && mkdir -p ${GPDB_BIN}
		echo "Removed the ${GPDB_BIN}"
	fi

	cd ${GPDB_SRC} || return

	# 使用git命令清理obj文件
	# git cl && git-reset-submodules

	_gpdb-configure "$@"

	# make clean ARCHFLAGS="-arch x86_64"
	# make clean

	# 不能使用 -j8
	# make ARCHFLAGS="-arch x86_64" && make install ARCHFLAGS="-arch x86_64"
	make

	if [[ ${choice} == 'y' ]];then
		make install
	fi

	cd ${cur_dir}
}

_gpdb-configure(){
	local cur_dir=`pwd`
	local orca_choice=""

	is_gpdb_src || return

	cd ${GPDB_SRC}

	export GPDB_ORCA_OPTION="--disable-orca"
	read -p "Enable ORCA? [y/n]?" orca_choice

	if [[ ${orca_choice} == 'y' ]];then
		GPDB_ORCA_OPTION=""
	fi

	if [[ ${gpdb_target} == '4' ]];then
		# just add the '--enable-thread-safety-force' option for gpdb4
		KCFLAGS=-ggdb3 CFLAGS="-O0 -g3" ./configure --with-perl \
			--with-extra-version="-baotingfang" \
			--with-python \
			--with-libxml \
			--prefix="$GPDB_BIN" \
			--enable-debug \
			${GPDB_ORCA_OPTION} \
			--enable-cassert \
			--enable-thread-safety-force
	else
		KCFLAGS=-ggdb3 CFLAGS="-O0 -g3" ./configure --with-perl \
			--with-extra-version="-baotingfang" \
			--with-python \
			--with-libxml \
			--prefix="$GPDB_BIN" \
			--enable-debug \
			--enable-cassert \
			${GPDB_ORCA_OPTION} \
			--with-gssapi \
			--with-zstd \
			--with-krb-srvnam=postgres
	 fi

	cd ${cur_dir}
}

_gpdb-reinit(){
	gpdb-env-set "$@"

	local cur_dir=`pwd`
	kill-postgres

	read -p "will remove ${GPDB_DATA_DIR} continue?[y/n]?" choice
	if [[ ${choice} != 'y' ]];then
		echo "stopped!"
		return
	fi

	rm -rf ${GPDB_DATA_DIR}/gp*/*
	gpdb-source "$@"

	cd "${OPT}/data/config" || return
	SHELL=/bin/bash "$GPDB_BIN/bin/gpinitsystem" -a -c "$INIT_CONFIG_NAME" || true

	${GPDB_BIN}/bin/createdb baotingfang
	${GPDB_BIN}/bin/createdb gpadmin

	${GPDB_BIN}/bin/createuser -s "$GPDB_KRB_USER"
	${GPDB_BIN}/bin/createuser -s gpadmin

	echo 'host	all	baotingfang 	0.0.0.0/0	trust' >> "$MASTER_DATA_DIRECTORY/pg_hba.conf"
	echo "host	all	$GPDB_KRB_USER  0.0.0.0/0	gss include_realm=0 krb_realm=SKYFREE.COM" >> "$MASTER_DATA_DIRECTORY/pg_hba.conf"
	${GPDB_BIN}/bin/gpconfig -c krb_server_keyfile -v  "$GPDB_KRB_KEYTAB"

	${GPDB_BIN}/bin/gpstop -au
	cd ${cur_dir}
}

gpdb-krb-keytab-sync(){
	gpdb-env-set "$@"
	local cur_dir=`pwd`

	kinit admin/admin
	kadmin -q "ktadd -k $GPDB_KRB_KEYTAB postgres/$MASTER_HOSTNAME@SKYFREE.COM kgpadmin/$MASTER_HOSTNAME@SKYFREE.COM"
	echo "sync done!"

	cd ${cur_dir}
}

gpdb-krb-login(){
	gpdb-env-set "$@"
	local cur_dir=`pwd`

	kdestroy -A
	kinit -kt ${GPDB_KRB_KEYTAB} ${GPDB_KRB_USER}
	psql -U "${GPDB_KRB_USER}" -h "${MASTER_HOSTNAME}" postgres
}

gpdb-krb-logout(){
	kdestroy -A
	echo "clean all cache."
}

gpdb-dep-mac(){
	# 注意: 在mac下一定要卸载:brew remove binutils, 这里的ar工具不能用!
	brew install flex bison
	brew install libxml2
	brew install conan

	# gporca
	brew install cmake
	brew install xerces-c

	# enables `--enable-mapreduce`
	brew install libyaml
	# gpfdist
	brew install libevent

	# gpperfmon
	brew install apr
	brew install apr-util

	brew install zstd

	brew link --force apr
	brew link --force apr-util
	brew link --force libxml2
}

gpdb-dep-centos(){
echo "
	# 参考下面的内容

	千万不能安装: xerces-c-devel, 需要使用pivotal提供的xerces-c库

	sudo yum install -y epel-release
	sudo yum install -y \
		apr-devel \
		bison \
		bzip2-devel \
		cmake3 \
		flex \
		gcc \
		gcc-c++ \
		krb5-devel \
		libcurl-devel \
		libevent-devel \
		libkadm5 \
		libyaml-devel \
		libxml2-devel \
		openssl-devel \
		perl-ExtUtils-Embed \
		python-devel \
		python-pip \
		readline-devel \
		zlib-devel

	yum install -y perl-devel perl-Env

	sudo pip install conan
	sudo ln -sf /usr/bin/cmake3 /usr/local/bin/cmake

	# add lib path
	sudo echo "/usr/local/lib" >> /etc/ld.so.conf
	sudo echo "/usr/local/lib64" >> /etc/ld.so.conf
	sudo ldconfig

	# enable gcc-6
	sudo yum install -y centos-release-scl
	sudo yum install -y devtoolset-6-toolchain
	echo 'source scl_source enable devtoolset-6' >> ~/.bashrc
	source scl_source enable devtoolset-6
"
}

gpdb-dep-rhel(){

echo "
	# 参考下面的内容

	千万不能安装: xerces-c-devel, 需要使用pivotal提供的xerces-c库

	sudo yum install -y epel-release
	sudo yum install -y \
		apr-devel \
		bison \
		bzip2-devel \
		cmake3 \
		flex \
		gcc \
		gcc-c++ \
		krb5-devel \
		libcurl-devel \
		libevent-devel \
		libkadm5 \
		libyaml-devel \
		libxml2-devel \
		openssl-devel \
		perl-ExtUtils-Embed \
		python-devel \
		python-pip \
		readline-devel \
		zlib-devel

	yum install -y perl-devel perl-Env

	sudo pip install conan
	sudo ln -sf /usr/bin/cmake3 /usr/local/bin/cmake

	# add lib path
	sudo echo "/usr/local/lib" >> /etc/ld.so.conf
	sudo echo "/usr/local/lib64" >> /etc/ld.so.conf
	sudo ldconfig

	# enable gcc-6
	sudo yum-config-manager --enable rhui-REGION-rhel-server-rhscl
	sudo yum install -y devtoolset-6-toolchain
"
}

gpdb-dep-ubuntu(){
echo "
	参考如下内容:

	> 千万不能安装 libxerces-c-dev, 需要使用pivotal提供的xerces-c库

	sudo apt-get update
	sudo apt-get install -y \
		bison \
		ccache \
		cmake \
		curl \
		flex \
		git-core \
		gcc \
		g++ \
		inetutils-ping \
		krb5-kdc \
		krb5-admin-server \
		libapr1-dev \
		libbz2-dev \
		libcurl4-gnutls-dev \
		libevent-dev \
		libkrb5-dev \
		libpam-dev \
		libperl-dev \
		libreadline-dev \
		libssl-dev \
		libxml2-dev \
		libyaml-dev \
		locales \
		net-tools \
		ninja-build \
		openssh-client \
		openssh-server \
		openssl \
		python-dev \
		python-lockfile \
		python-paramiko \
		python-pip \
		python-psutil \
		python-yaml \
		zlib1g-dev

	pip install conan

	# enable gcc-6
	sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
	sudo apt-get update
	sudo apt-get install -y gcc-6 g++-6
"
}

gpdb-kernel-config-linux(){

echo "
	参考如下内容:

	sudo bash -c 'cat >> /etc/sysctl.conf <<-EOF
kernel.shmmax = 500000000
kernel.shmmni = 4096
kernel.shmall = 4000000000
kernel.sem = 500 1024000 200 4096
kernel.sysrq = 1
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.msgmni = 2048
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.conf.all.arp_filter = 1
net.ipv4.ip_local_port_range = 1025 65535
net.core.netdev_max_backlog = 10000
net.core.rmem_max = 2097152
net.core.wmem_max = 2097152
vm.overcommit_memory = 2

EOF'

	sudo bash -c 'cat >> /etc/security/limits.conf <<-EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 131072
* hard nproc 131072

EOF'

	sudo bash -c 'cat >> /etc/ld.so.conf <<-EOF
/usr/local/lib
/usr/local/lib64

EOF'
"
}

gpdb-kernel-config-mac(){
echo "
	参考如下内容:

	sudo sysctl -w kern.sysv.shmmax=2147483648
	sudo sysctl -w kern.sysv.shmmin=1
	sudo sysctl -w kern.sysv.shmmni=64
	sudo sysctl -w kern.sysv.shmseg=16
	sudo sysctl -w kern.sysv.shmall=524288
	sudo sysctl -w net.inet.tcp.msl=60

	sudo sysctl -w net.local.dgram.recvspace=262144
	sudo sysctl -w net.local.dgram.maxdgram=16384
	sudo sysctl -w kern.maxfiles=131072
	sudo sysctl -w kern.maxfilesperproc=131072
	sudo sysctl -w net.inet.tcp.sendspace=262144
	sudo sysctl -w net.inet.tcp.recvspace=262144
	sudo sysctl -w kern.ipc.maxsockbuf=8388608

	sudo tee -a /etc/sysctl.conf << EOF
kern.sysv.shmmax=2147483648
kern.sysv.shmmin=1
kern.sysv.shmmni=64
kern.sysv.shmseg=16
kern.sysv.shmall=524288
net.inet.tcp.msl=60
net.local.dgram.recvspace=262144
net.local.dgram.maxdgram=16384
kern.maxfiles=131072
kern.maxfilesperproc=131072
net.inet.tcp.sendspace=262144
net.inet.tcp.recvspace=262144
kern.ipc.maxsockbuf=8388608
EOF
"
}

gpdb-docs-share(){
	cp -R ~/wiki/0000.Pivotal/007.gpdb/* ${HOME}/github/baotingfang/gpdb-cn/

	now=`date +%Y%m%d%H%M%S`
	pushd ${HOME}/github/baotingfang/gpdb-cn/
	git add -A
	git commit -m "commit at $now"
	git push origin master
	popd

	echo "done"
}

gpdb-test(){
	local cur_dir=`pwd`

	cd ${WB}/gpdb/src/test/regress || return
	./pg_regress --schedule=my_test.schedule --init-file=init_file
	cd ${cur_dir}
}

psql-utility(){
	# https://community.pivotal.io/s/article/FAQ---Greenplum-Administration-for-DBA-Part-I-General
	PGOPTIONS='-c gp_session_role=utility' psql "$@"
}

psql-retrieve(){
	# https://community.pivotal.io/s/article/FAQ---Greenplum-Administration-for-DBA-Part-I-General
	PGOPTIONS='-c gp_session_role=retrieve' psql "$@"
}

gpdb-switch(){
	local cur_dir=`pwd`

	echo "usage: gpdb-switch dev|reading"
	name=${1:-dev}

	if [[ -h "$WB/gpdb" ]]
	then
		rm -f "$WB/gpdb"
	fi

	ln -s "${WB}/gpdb-$name" ${WB}/gpdb
	echo "switch to gpdb-$name"

	cd ${cur_dir}
}

gpdb-orca-compile(){
	# 可以从gpdb-orca-taglist
	tag=${1:-master}
	cur_dir=`pwd`

	cd "$WB/gporca"
	git clean -fdx
	git --no-pager branch|grep ${tag}

	if [[ $? != 0 ]];then
		git checkout -b ${tag} ${tag}
	else
		git checkout ${tag}
	fi

	mkdir build && cd build
	cmake ../

	make -j
	sudo make install

	cd ${cur_dir}
}

gpdb-gp-xerces-compile(){

	tag='master'
	cur_dir=`pwd`

	if [[ `uname -s` != 'Linux' ]];then
		echo "Just compile gp-xerces on linux!"
		return
	fi

	cd "$WB/gp-xerces" || return
	git clean -fdx
	git checkout ${tag}
	git pull

	mkdir build && cd build
	../configure --prefix=/usr/local

	make
	sudo make install

	cd ${cur_dir}
}

gpdb-gpos-compile(){

	tag='master'
	cur_dir=`pwd`

	if [[ `uname -s` != 'Linux' ]];then
		echo "Just compile gp-xerces on linux!"
		return
	fi

	cd "$WB/gpos" || return
	git clean -fdx
	git checkout ${tag}
	git pull

	mkdir build && cd build
	cmake ../

	make
	sudo make install

	cd ${cur_dir}
}

gpdb-orca-taglist(){
	cur_dir=`pwd`

	cd "$WB/gporca" || return
	git --no-pager tag
	cd ${cur_dir}
}

gpdb-master-pid(){
	ps -ef|grep "postgres -D"|grep -v grep|grep gpmaster| awk '{print $2}'
}

gpdb-qd-pid(){
	ps -ef|grep "postgres"|grep 127.0.0.1|grep 5432|grep con|grep -v grep| awk '{print $2}'
}

gpdb-segment0-master-pid(){
	ps -ef|grep "postgres -D"|grep -v grep|grep gpsne0| awk '{print $2}'
}

gpdb-stub(){
	# 只是方便在CLION中快速编译, 测试stub代码, 执行不成功也是正常的!
	if [[ `uname -s` == 'Darwin' ]];then
		g6 && make install && (gpstop -arf || gpstart -a) && lldb-gpdb-master
	else
		g6 && make install && (gpstop -arf || gpstart -a) && gdb-gpdb-master
	fi
}

_gpdb-mpp-compile(){
	echo "usage: gpdb-mpp-compile quick|all"

	local cur_dir=`pwd`
	local option=${1:-quick}
	echo "option: ${option}"

	gpdb-env-set "$@"

	is_gpdb_src || return

	if [[ ${option} == 'all' ]];then
		cd ${GPDB_SRC}
		make && make install
	fi

	cd ${GPDB_SRC}/contrib/postgres_fdw
	make install

	cd ${cur_dir}
}

sync-gpdb5-tools(){
	cp "${OPT}/gpdb/bin/psql" "${HOME}/tmp/bin/6.x/"
	cp "${OPT}/gpdb/bin/pg_dump" "${HOME}/tmp/bin/6.x/"
	cp "${OPT}/gpdb/bin/pg_dumpall" "${HOME}/tmp/bin/6.x/"
}

sync-gpdb4-tools(){
	cp "${OPT}/gpdb4/bin/psql" "${HOME}/tmp/bin/4.x/"
	cp "${OPT}/gpdb4/bin/pg_dump" "${HOME}/tmp/bin/4.x/"
	cp "${OPT}/gpdb4/bin/pg_dumpall" "${HOME}/tmp/bin/4.x/"
}
