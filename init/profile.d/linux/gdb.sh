#!/usr/bin/env bash

gdb-gpdb(){
	gpdb-ps

	echo -n "请选择进程号:"
	read PID

	gdb -p ${PID}
}

