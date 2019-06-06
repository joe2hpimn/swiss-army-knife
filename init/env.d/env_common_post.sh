#!/usr/bin/env bash
# shellcheck disable=1090

# 系统自带工具路径
INIT_PATH="${INIT_PATH}:/usr/bin:/usr/sbin:/bin:/sbin"
INIT_PATH="${INIT_PATH}:${SYS_PATH}"

export INIT_PATH
export PATH=${INIT_PATH}:${PATH}

# Direnv hook
eval "$(direnv hook zsh)"

# rvm
[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"
