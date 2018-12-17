#!/usr/bin/env bash

hello() {
  echo baotingfang is here!
}

green(){
	echo -e "\033[32m ${1:-''} \033[0m"
}

get_os_name(){
	# lsb_release -i|awk '{print $3}'|tr -d " "

	# centos, darwin, ubuntu
	local os_name=`python -c "import platform; print platform.system()"`

	if [[ ${os_name} == 'Darwin' ]];then
		python -c "print '${os_name}'.lower()"
	else
		python -c "import platform; print platform.dist()[0].lower()"
	fi
}

get_os(){
	# linux, darwin, ....
	python -c "import platform; print platform.system().lower()"
}