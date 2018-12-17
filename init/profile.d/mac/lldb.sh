#!/usr/bin/env bash

lldb-gpdb-qd(){
	lldb -p `gpdb-qd-pid`
}

lldb-gpdb-master(){
	lldb -p `gpdb-master-pid`
}

lldb-gpdb-segment0-master(){
	lldb -p `gpdb-segment0-master-pid`
}

