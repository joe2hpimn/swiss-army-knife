#!/usr/bin/env bash

if [[ $SHELL == '/bin/zsh' ]];then
	unsetopt nomatch
	unsetopt AUTO_CD
fi

# go
export GOPATH="$HOME/go-projects"
export GOBIN="$HOME/go-projects/bin"

# java
export JAVA_HOME="$OPT/java"
export ANT_HOME="$OPT/ant/"
export M2_HOME="$OPT/mvn"
export MAVEN_OPTS="-Xms512m -Xmx1024m"
export GROOVY_HOME="$OPT/groovy"

# PATH
# 通用工具
INIT_PATH="$HOME/bin:$HOME/bin/my-tools:$HOME/tools:/usr/local/bin:/usr/local/sbin"

# python
INIT_PATH="$HOME/.local/bin:$INIT_PATH"

# golang
INIT_PATH="$INIT_PATH:$GOROOT/bin:$GOBIN"

# java
INIT_PATH="$INIT_PATH:$JAVA_HOME/bin:$ANT_HOME/bin:$M2_HOME/bin:$GROOVY_HOME/bin"

# 系统自带工具路径
INIT_PATH="$INIT_PATH:/usr/bin:/usr/sbin:/bin:/sbin:$SYS_PATH"

export INIT_PATH
export PATH=${INIT_PATH}

# Direnv hook
eval "$(direnv hook zsh)"
