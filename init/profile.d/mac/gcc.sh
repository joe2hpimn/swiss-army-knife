#!/usr/bin/env bash

gcc-enable(){
	alias gcc='/usr/local/bin/gcc-9'
	alias g++='/usr/local/bin/g++-9'
	alias c++='/usr/local/bin/c++-9'
}

gcc-disable(){
	unalias gcc
	unalias g++
	unalias c++
}