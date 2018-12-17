#!/usr/bin/env bash

gdb-gpdb-qd(){
	gdb -p `gpdb-qd-pid`
}

gdb-gpdb-master(){
	gdb -p `gpdb-master-pid`
}

gdb-gpdb-segment0-master(){
	gdb -p `gpdb-segment0-master-pid`
}