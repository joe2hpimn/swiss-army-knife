#!/bin/bash

source $HOME/bin/init/global_functions.sh

# Basic Work Dir
export OPT="$HOME/opt"
export WB="$HOME/workspace"
export BASE_DIR="$HOME/bin"

# init local env settings
[[ ! -f ${HOME}/.env ]] && touch ${HOME}/.env
source $HOME/.env

# restore the init PATH
if [[ ${SYS_PATH} ]];then
	green "重新载入zshrc配置..."
else
	export SYS_PATH=${PATH}
fi

# 只支持zsh环境
unsetopt nomatch
unsetopt AUTO_CD

source "${BASE_DIR}/init/env.d/env_common.sh"

if [[ `get_os` == 'darwin' ]];then
	source "$BASE_DIR/init/env.d/env_mac.sh"
else
	source "$BASE_DIR/init/env.d/env_linux.sh"
fi

source $HOME/bin/init/alias.sh
source $HOME/bin/init/profile.sh

# archey -o

[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh" || true