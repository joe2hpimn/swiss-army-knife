#!/usr/bin/env bash

if [[ $SHELL == '/bin/zsh' ]];then
	unsetopt nomatch
	unsetopt AUTO_CD
fi

export GOPATH="${HOME}/go-projects"
export GOBIN="${HOME}/go-projects/bin"

# java
export JAVA_HOME="${OPT}/java"
export ANT_HOME="${OPT}/ant/"
export M2_HOME="${OPT}/mvn"
export MAVEN_OPTS="-Xms512m -Xmx1024m"
export GROOVY_HOME="${OPT}/groovy"

# INIT PATH
INIT_PATH="${INIT_PATH}:$GOBIN"

# java
INIT_PATH="${INIT_PATH}:${JAVA_HOME}/bin:${ANT_HOME}/bin:${M2_HOME}/bin:${GROOVY_HOME}/bin"
