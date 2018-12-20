#!/usr/bin/env bash

lldb-gpdb(){
	gpdb-ps

	echo -n "请选择进程号:"
	read PID

	# /usr/bin/read -p "请选择进程号:" PID
	lldb -p ${PID}
}

