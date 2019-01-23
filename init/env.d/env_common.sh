#!/usr/bin/env bash

# used in gpdb complie
export MAKEFLAGS='-j8'
export KCFLAGS="-ggdb3"
export CFLAGS="-O0 -g3"

# main job recently
export CWD_PATH="$WB/go/src/github.com/pivotal/gpcopy"

# pg settings
export PGDATABASE="baotingfang"
export PGHOST="127.0.0.1"
export PGPORT="5432"

# concourse
export CONCOURSE_TARGET=local
export CONCOURSE_URL="http://ci.skyfree.home"
export EDITOR=vim

# lang
# export LANG=zh_CN.UTF-8
# export LC_CTYPE=zh_CN.UTF-8

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# git-author
export GIT_TOGETHER_NO_SIGNOFF=1

# include my tool box
export INIT_PATH=${BASE_DIR}/my-tools:${BASE_DIR}:${INIT_PATH}
