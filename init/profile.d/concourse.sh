#!/usr/bin/env bash

fly-env-set(){
	export CONCOURSE_TARGET=${1:-local}

	if [[ ${CONCOURSE_TARGET} == 'local' ]];then
		export CONCOURSE_URL='http://ci.skyfree.home'
	elif [[ ${CONCOURSE_TARGET} == 'dev' ]];then
		export CONCOURSE_URL='https://dev.ci.gpdb.pivotal.io'
	elif [[ ${CONCOURSE_TARGET} == 'prod' ]];then
		export CONCOURSE_URL='https://dev.ci.gpdb.pivotal.io'
	fi

	fly-env-show
}

fly-env-show(){
	echo "CURRENT TARGET: ${CONCOURSE_TARGET}"
	echo "CURRENT    URL: ${CONCOURSE_URL}"
}

flyme(){
	local cur_dir=`pwd`

	[[ -z ${CONCOURSE_TARGET} ]] &&  echo "please fly-env-set first!" && return

	fly-env-show
	$HOME/tools/fly -t ${CONCOURSE_TARGET} "$@"

	cd ${cur_dir}
}

fly-env-clear(){
	unset CONCOURSE_TARGET
	unset CONCOURSE_URL
}

fly-login(){
	local cur_dir=`pwd`

	# fly -t <env_name> login -c <URL> -u <username> -p <password>
	flyme login -c ${CONCOURSE_URL}

	cd ${cur_dir}
}

fly-workers(){
	local cur_dir=`pwd`

	flyme workers

	cd ${cur_dir}
}

fly-quick-helper(){

	echo "1.设置pipeline\n\n\tflyme sp -p <pipeline_name> -c <pipeline.yml>"

	echo ""
}

