#!/usr/bin/env bash



source_common(){
	# Cross platform tools
	if [[ -d $HOME/bin/init/profile.d ]]; then
		green "Init Common System...."
		for i in $HOME/bin/init/profile.d/*.sh; do
			if [[ -r ${i} ]]; then
				. ${i}
			fi
		done
		unset i
	fi
}

source_common_linux(){
	os_name=`get_os`
	if [[ ${os_name} == 'linux' ]] && [[ -d $HOME/bin/init/profile.d/ubuntu ]]; then
		green "Init Linux System...."
		for i in $HOME/bin/init/profile.d/linux/*.sh; do
			if [[ -r ${i} ]]; then
				. ${i}
			fi
		done
		unset i
	fi
}

source_dist(){
	local dist_name=`get_os_name`

	case ${dist_name} in
		darwin)
			if [[ -d $HOME/bin/init/profile.d/mac ]]; then
				green "Init Mac System...."
				for i in $HOME/bin/init/profile.d/mac/*.sh; do
					if [[ -r ${i} ]]; then
						. ${i}
					fi
				done
				unset i
			fi
			;;
		ubuntu)
			if [[ -d $HOME/bin/init/profile.d/ubuntu ]]; then
				green "Init Ubuntu System...."
				for i in $HOME/bin/init/profile.d/ubuntu/*.sh; do
					if [[ -r ${i} ]]; then
						. ${i}
					fi
				done
				unset i
			fi
			;;
		centos)
			if [[ -d $HOME/bin/init/profile.d/centos ]]; then
				green "Init CentOS System..."
				for i in $HOME/bin/init/profile.d/centos/*.sh; do
					if [[ -r ${i} ]]; then
						. ${i}
					fi
				done
				unset i
			fi
			;;
		*)
			green -e "Not Support $dist_name System"
			;;
	esac
}

source_scripts(){
	source_common
	source_common_linux
	source_dist
}

source_scripts





