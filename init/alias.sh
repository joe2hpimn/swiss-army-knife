#!/usr/bin/env bash

source "${BASE_DIR}/init/alias.d/alias_common.sh"

if [[ `uname -s` == 'Darwin' ]];then
	source "$BASE_DIR/init/alias.d/alias_mac.sh"
else
	source "$BASE_DIR/init/alias.d/alias_linux.sh"
fi
