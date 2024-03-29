#!/usr/bin/env bash
#shellcheck disable=1090,2155

source-common(){
	# 所有平台通用的环境变量
	source "${BASE_DIR}/init/env.d/env_common_before.sh"

	# 导入全平台通用别名集合
	source "${BASE_DIR}/init/alias.d/alias_common.sh"

	# 导入全平台支持的自定义工具
	if [[ -d ${BASE_DIR}/init/profile.d ]]; then
		green "初始化通用系统...."
		for i in ${BASE_DIR}/init/profile.d/*.sh; do
			if [[ -r ${i} ]]; then
				. ${i}
			fi
		done
		unset i
	fi
}

source-common-linux(){
	# 导入linux平台的别名集合
	source "${BASE_DIR}/init/alias.d/alias_linux.sh"

	os_name=`get-os`
	if [[ ${os_name} == 'linux' ]]; then
		green "初始化 Linux 系统...."
		for i in ${BASE_DIR}/init/profile.d/linux/*.sh; do
			if [[ -r ${i} ]]; then
				. ${i}
			fi
		done
		unset i
	fi
}

source-dist(){
	local dist_name="$(get-os-name)"

	case ${dist_name} in
		darwin)
			# 导入Mac平台的环境变量
			source "${BASE_DIR}/init/env.d/env_mac.sh"

			# 导入Mac平台特定的别名集合
			source "${BASE_DIR}/init/alias.d/alias_mac.sh"

			if [[ -d ${BASE_DIR}/init/profile.d/mac ]]; then
				green "初始化Mac系统...."
				for i in ${BASE_DIR}/init/profile.d/mac/*.sh; do
					if [[ -r ${i} ]]; then
						. ${i}
					fi
				done
				unset i
			fi
			;;
		ubuntu)
			# 导入Ubuntu的环境变量集合
			source "${BASE_DIR}/init/env.d/env_ubuntu.sh"

			if [[ -d ${BASE_DIR}/init/profile.d/ubuntu ]]; then
				green "初始化Ubuntu系统...."
				for i in ${BASE_DIR}/init/profile.d/ubuntu/*.sh; do
					if [[ -r ${i} ]]; then
						. ${i}
					fi
				done
				unset i
			fi
			;;
		centos)
			# 导入centos的环境变量集合
			source "${BASE_DIR}/init/env.d/env_centos.sh"

			if [[ -d ${BASE_DIR}/init/profile.d/centos ]]; then
				green "初始化CentOS系统..."
				for i in ${BASE_DIR}/init/profile.d/centos/*.sh; do
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

source-common-post() {
	source "${BASE_DIR}/init/env.d/env_common_post.sh"
}

source-scripts(){
	source-common
	source-common-linux
	source-dist
	source-common-post

	export INIT_PATH="${INIT_PATH}"
}

source-scripts
