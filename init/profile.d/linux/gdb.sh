#!/usr/bin/env bash

gdb-gpdb(){
	# 需要设置 kernel.yama.ptrace_scope = 0
	gpdb-ps

	echo -n "请选择进程号:"
	read PID

	gdb -p ${PID}
}

