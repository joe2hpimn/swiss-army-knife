#!/usr/bin/env bash
#shellcheck disable=2155,2164,2128,2206

fly-env-set(){
	export CONCOURSE_TARGET=${1:-local}

	if [[ ${CONCOURSE_TARGET} == 'local' ]];then
		export CONCOURSE_URL='http://ci.skyfree.home:8080'
	elif [[ ${CONCOURSE_TARGET} == 'gpdb-dev' ]];then
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
	fly -t ${CONCOURSE_TARGET} "$@"

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

concourse-start(){
	local cur_dir=`pwd`
	local compose_file="${BASE_DIR}/docker/concourse.yml"

	# wget -O ${compose_file} https://concourse-ci.org/docker-compose.yml
	docker-compose -f ${compose_file} up -d
	echo "Concourse Started! [http://ci.skyfree.home:8080 username/password=test/test]"

	cd ${cur_dir}
}

concourse-stop(){
	local cur_dir=`pwd`
	local option=${1:-}
	local compose_file="${BASE_DIR}/docker/concourse.yml"


	# wget -O ${compose_file} https://concourse-ci.org/docker-compose.yml

	if [[ ${option} == '--prune' ]];then
		docker-compose -f ${compose_file} down
	else
		docker-compose -f ${compose_file} stop
	fi
	echo "Concourse stopped!"
	echo "You can purge the concourse by '`basename $0` --prune'"
	cd ${cur_dir}
}

_concourse-status(){
		cur_dir=`pwd`
		pipelines=($@)

		ARGS=$(IFS=, ; echo "${pipelines[*]}")
		URL="https://pipelinedashboard.cfapps.io/?pipelines=${ARGS}"
		echo ${URL} && open ${URL}

		cd ${cur_dir}
}

concourse-status-prod(){
		pipelines=(
		prod:gpdb_master
		prod:gpdb_master_without_asserts
		prod:4.3_STABLE
		prod:5X_STABLE
		prod:6X_STABLE
		prod:6X_STABLE_without_asserts
		prod:gpdb5-integration-testing
		prod:gpdb6-integration-testing
		prod:build_bot
		)

		_concourse-status ${pipelines}
}

concourse-status-teams(){
		pipelines=(
		prod:gpcopy-release
		prod:gpss-release
		prod:pxf_release_5x
		prod:pxf_release_master
		prod:gptext_release
		prod:4.3_gp_filedump_release
		)
		_concourse-status ${pipelines}
}

concourse-status-releng(){
		pipelines=(prod:6X-release
		prod:5X-release
		prod:4.3-release
		prod:state-checker
		prod:pg-postgres-release
		ts:cloud-vm-image-baking
		ts:docker-image-baking
		ts:pivnet_client_integration_test
		ts:gcs-bucket-testing
		ts:ccp-integration-tests-google
		ts:gpdb-build-artifacts) &&
		_concourse-status ${pipelines}
}