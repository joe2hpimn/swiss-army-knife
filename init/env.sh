#!/usr/bin/env bash

# 全局用到的目录位置
export BASE_DIR="$HOME/toolbox"
export OPT="$HOME/opt"
export WB="$HOME/workspace"

# 引入全局函数, 主要与安装工具箱有关
source "${BASE_DIR}/starter/functions.sh"

# 只支持zsh环境
unsetopt nomatch
unsetopt AUTO_CD

# 初始化本地用户自定义设置
[[ ! -f ${HOME}/.env ]] && touch ${HOME}/.env
source $HOME/.env

# 保存系统初始化PATH环境变量, 用于之后的重置zsh环境.
if [[ -n ${SYS_PATH} ]]; then
	green "重新载入zshrc配置..."
else
	export SYS_PATH=${PATH}
fi

# 根据不同平台, 导入不同的自定义工具集合
source ${BASE_DIR}/init/profile.sh

# 小玩具
# archey -o

[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh" || true