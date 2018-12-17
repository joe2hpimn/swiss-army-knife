#!/usr/bin/env bash

export GPCOPY_GOPATH="$HOME/workspace/go"
export GPCOPY_HOME="$GPCOPY_GOPATH/src/github.com/pivotal/gpcopy"

gpcopy-env(){
	echo "Usage: gpcopy-env 5 c 3t3"

	export GPCOPY_GP_VERSION=${1:-6}
	echo "gpdb: ${GPCOPY_GP_VERSION}"

	# the $version is the first command line parameter
	if [[ ${GPCOPY_GP_VERSION} == '-h' ]];then
		echo `basename $0`"\n  support:\n    version: 4,5,6,4t5\n    coverage: c"
		return
	fi

	# 启用代码覆盖率， coverage的值应该为：'c'
	export GPCOPY_COVERAGE=${2:-x}
	echo "coverage mode: ${GPCOPY_COVERAGE}"

	export GPCOPY_GP_SIZE=${3:-'3t3'}
	echo "gpdbsize: ${GPCOPY_GP_SIZE}"

	export GOPATH=${GPCOPY_GOPATH}
	echo "GOPATH: ${GOPATH}"

	# just in order to get the gpscp command
	unset PYTHONPATH
	unset PYTHONHOME

	export GPCOPY_SRC_GPHOME="/usr/local/gpdb"
	export GPCOPY_DEST_GPHOME="/usr/local/gpdb"
	export GPCOPY_SRC_USER="gpadmin"
	export GPCOPY_DEST_USER="gpadmin"

	if [[ "$GPCOPY_GP_VERSION" == '5' || "$GPCOPY_GP_VERSION" == '6' ]];then
		source "$OPT/gpdb/greenplum_path.sh"
		export PATH="$HOME/tmp/bin/6.x:$PATH"
		export GPCOPY_SRC_HOST=mdw
		export GPCOPY_DEST_HOST=mdw-2
	fi

	if [[ "$GPCOPY_GP_VERSION" == '4' ]];then
		source "$OPT/gpdb4/greenplum_path.sh"
		export PATH="$HOME/tmp/bin/4.x:$PATH"
		export GPCOPY_SRC_HOST=mdw-gpdb4
		export GPCOPY_DEST_HOST=mdw-2-gpdb4
	fi

	if [[ "$GPCOPY_GP_VERSION" == '4t5' ]];then
		source "$OPT/gpdb4/greenplum_path.sh"
		export PATH="$HOME/tmp/bin/6.x:$PATH"
		export GPCOPY_SRC_HOST=mdw-gpdb4
		export GPCOPY_DEST_HOST=mdw-2
	fi

	export SRCHOST=${GPCOPY_SRC_HOST}
	export DESTHOST=${GPCOPY_DEST_HOST}
}

gpcopy-env-clear(){

	echo "清除gpcopy的环境变量..."

	unset GPCOPY_GP_VERSION
	unset GPCOPY_COVERAGE
	unset GPCOPY_GP_SIZE
	unset GPCOPY_SRC_GPHOME
	unset GPCOPY_DEST_GPHOME
	unset GPCOPY_SRC_USER
	unset GPCOPY_DEST_USER
	unset GPCOPY_SRC_HOST
	unset GPCOPY_DEST_HOST

	unset SRCHOST
	unset DESTHOST
	unset SRCPORT
	unset DESTPORT
	unset SRCUSR
	unset DESTUSR

	echo "clear all gpcopy envs!:)"
}

gpcopy-env-show(){
	echo "GPCOPY_GP_VERSION: $GPCOPY_GP_VERSION"
	echo "GPCOPY_COVERAGE: $GPCOPY_COVERAGE"
	echo "GPCOPY_GP_SIZE: $GPCOPY_GP_SIZE"
	echo "GPCOPY_SRC_GPHOME: $GPCOPY_SRC_GPHOME"
	echo "GPCOPY_DEST_GPHOME}: $GPCOPY_DEST_GPHOME"
	echo "GPCOPY_SRC_USER: $GPCOPY_SRC_USER"
	echo "GPCOPY_DEST_USER: $GPCOPY_DEST_USER"
	echo "GPCOPY_SRC_HOST: $GPCOPY_SRC_HOST"
	echo "GPCOPY_DEST_HOST: $GPCOPY_DEST_HOST"

	# end2end env
	echo "SRCHOST: $SRCHOST"
	echo "DESTHOST: $DESTHOST"
	echo "SRCPORT: $SRCPORT"
	echo "DESTPORT: $DESTPORT"
	echo "SRCUSR: $SRCUSR"
	echo "DESTUSR: $DESTUSR"

	echo "PATH: $PATH"
}

_gpcopy-all-tests(){
	cur_dir=`pwd`

	gpcopy-env "$@"
	gpcopy-env-show

	cd ${GPCOPY_HOME}

	make clean
	make build
	make build_linux
	make build_test

	ssh ${GPCOPY_SRC_USER}@${GPCOPY_SRC_HOST} 'rm -rf /tmp/gpcopy_end2end/*.cov && pkill gpcopy && pkill gpcopy_helper || true'
	ssh ${GPCOPY_DEST_USER}@${GPCOPY_DEST_HOST} 'rm -rf /tmp/gpcopy_end2end/*.cov && pkill gpcopy && pkill gpcopy_helper || true'

	_gpcopy-copy-gpcopy

	# 以下是gpdb-reinit的脚本内容
	# #!/bin/bash

	# main(){
	# 	local init_seg_count=${1:-3}
	# 	local force=${2:-'x'}
	# 	echo 'Init Segment Size: '$init_seg_count
	# 	echo 'force: '$force
	#
	# 	curr_seg_count=`psql -t -c 'select count(*) from gp_segment_configuration where content > -1;'|awk '{$1=$1;print}'|grep -v  "^$"` || echo -1
	# 	echo "Current Segment Size: "$curr_seg_count
	# 	if [[ "$init_seg_count" -eq "$curr_seg_count" && $force = 'x' ]];then
	# 		echo "The same segment size, skip"
	# 		return
	# 	fi
	#
	# 	kill-postgres
	# 	rm -rf /gp*/*
	# 	cd /home/gpadmin/config
	#
	# 	gpinitsystem -a -c gpinitsystem_singlenode_$init_seg_count
	# 	echo 'host	all	all	0.0.0.0/0	trust' >> $MASTER_DATA_DIRECTORY/pg_hba.conf
	# 	gpstop -au
	# 	createdb
	# }
	#
	# main $*

	# 同构测试
	if [[ ${GPCOPY_GP_SIZE} == '3t3' ]]; then
		ssh ${GPCOPY_SRC_USER}@${GPCOPY_SRC_HOST} "/bin/bash --login ~/bin/gpdb-reinit 3"
		ssh ${GPCOPY_DEST_USER}@${GPCOPY_DEST_HOST} "/bin/bash --login ~/bin/gpdb-reinit 3"
	fi

	# 少到多测试
	if [[ ${GPCOPY_GP_SIZE} == '3t4' ]]; then
		ssh ${GPCOPY_SRC_USER}@${GPCOPY_SRC_HOST} '/bin/bash --login ~/bin/gpdb-reinit 3'
		ssh ${GPCOPY_DEST_USER}@${GPCOPY_DEST_HOST} '/bin/bash --login ~/bin/gpdb-reinit 4'
	fi

	# 多到少测试
	if [[ ${GPCOPY_GP_SIZE} == '4t3' ]]; then
		ssh ${GPCOPY_SRC_USER}@${GPCOPY_SRC_HOST} '/bin/bash --login /home/gpadmin/bin/gpdb-reinit 4'
		ssh ${GPCOPY_DEST_USER}@${GPCOPY_DEST_HOST} '/bin/bash --login /home/gpadmin/bin/gpdb-reinit 3'
	fi

	if [[ ${GPCOPY_COVERAGE} == "c" ]]; then
		_gpcopy-copy-test-helper
		make coverage
	else
		_gpcopy-copy-helper
		make unit
		make end2end
	fi

	rm -rf gpcopy_linux gpcopy_helper_linux
	rm -rf gpcopy_mac gpcopy_helper_mac

	gpcopy-env-clear

	cd ${cur_dir}
}

_gpcopy-sync(){
	cur_dir=`pwd`

	gpcopy-env "$@"
	gpcopy-env-show

	cd ${GPCOPY_HOME}

	make clean
	make build_linux
	make build_mac
	make build_test

	_gpcopy-copy-gpcopy

	if [[ ${GPCOPY_COVERAGE} == "c" ]]; then
		_gpcopy-copy-test-helper
	else
		_gpcopy-copy-helper
	fi

	gpcopy-env-clear

	cd ${cur_dir}
}

_gpcopy-copy-test-helper(){
	scp ${GOPATH}/bin/gpcopy_helper.test ${GPCOPY_SRC_USER}@${GPCOPY_SRC_HOST}:${GPCOPY_SRC_GPHOME}/bin/gpcopy_helper.test
	scp ${GOPATH}/bin/gpcopy_helper.test ${GPCOPY_DEST_USER}@${GPCOPY_DEST_HOST}:${GPCOPY_DEST_GPHOME}/bin/gpcopy_helper.test

	scp -p end2end/scripts/gpcopy_helper.sh ${GPCOPY_SRC_USER}@${GPCOPY_SRC_HOST}:${GPCOPY_SRC_GPHOME}/bin/gpcopy_helper
	scp -p end2end/scripts/gpcopy_helper.sh ${GPCOPY_DEST_USER}@${GPCOPY_DEST_HOST}:${GPCOPY_DEST_GPHOME}/bin/gpcopy_helper
}

_gpcopy-copy-helper(){
	scp gpcopy_helper_linux ${GPCOPY_SRC_USER}@${GPCOPY_SRC_HOST}:${GPCOPY_SRC_GPHOME}/bin/gpcopy_helper
	scp gpcopy_helper_linux ${GPCOPY_DEST_USER}@${GPCOPY_DEST_HOST}:${GPCOPY_DEST_GPHOME}/bin/gpcopy_helper
}

_gpcopy-copy-gpcopy(){
	scp gpcopy_linux ${GPCOPY_SRC_USER}@${GPCOPY_SRC_HOST}:${GPCOPY_SRC_GPHOME}/bin/gpcopy
	scp gpcopy_linux ${GPCOPY_DEST_USER}@${GPCOPY_DEST_HOST}:${GPCOPY_DEST_GPHOME}/bin/gpcopy
}