#!/usr/bin/env bash
#shellcheck disable=2155,2164

gcc-enable(){
	local cur_dir=`pwd`
	gcc_version=${1:-9}

	cd /usr/local/bin

	ln -s gcc-${gcc_version} gcc
	ln -s g++-${gcc_version} g++
	ln -s c++-${gcc_version} c++
	ln -s cpp-${gcc_version} cpp

	cd ${cur_dir}
}

gcc-disable(){
	local cur_dir=`pwd`

	cd /usr/local/bin

	[[ -L gcc ]] && rm -f gcc
	[[ -L g++ ]] && rm -f g++
	[[ -L c++ ]] && rm -f c++
	[[ -L cpp ]] && rm -f cpp

	cd ${cur_dir}
}