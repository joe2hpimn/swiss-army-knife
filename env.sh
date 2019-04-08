#!/usr/bin/env bash

BASE_DIR=$(cd `dirname $0`; pwd)
source ${BASE_DIR}/global.sh

# only work for zsh
unsetopt nomatch
# unsetopt AUTO_CD

[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh" || true

# init local config
[[ ! -f ${HOME}/.env ]] && touch ${HOME}/.env
source ${HOME}/.env

# 保存系统初始化PATH环境变量, 用于之后的重置zsh环境.
if [[ -n ${SYS_PATH} ]]; then
	green "重新载入zshrc配置..."
	export PATH=${SYS_PATH}
else
	export SYS_PATH=${PATH}
fi

# Support: Mac, CentOS, Ubuntu
source ${BASE_DIR}/init/profile.sh

# my toy on Mac
# archey -o
