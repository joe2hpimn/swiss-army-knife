#!/usr/bin/env bash

gcc-enable(){
	alias gcc='/usr/local/bin/gcc-8'
	alias g++='/usr/local/bin/g++-8'
	alias c++='/usr/local/bin/c++-8'
}

gcc-disable(){
	unalias gcc
	unalias g++
	unalias c++
}