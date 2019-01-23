#!/usr/bin/env bash

# only work on MacOS

#
ulimit -n 65536 65536

# core dump无大小限制
ulimit -c unlimited

if [[ $SHELL == '/bin/zsh' ]];then
	unsetopt nomatch
	# fpath=(/usr/local/share/zsh-completions $fpath)
	# fpath=(~/.zsh/Completion $fpath)
	# RPROMPT="hay"
	# Stop zsh from autocompleting CD operations without typing cd
	unsetopt AUTO_CD
fi

# OPT AND HOME
export BREW="/usr/local/opt"

# go
export GOROOT="$BREW/go/libexec"
export GOPATH="$HOME/go-projects"
export GOBIN="$HOME/go-projects/bin"

# java
export JAVA_HOME="$OPT/java"
export ANT_HOME="$OPT/ant/"
export KOTLIN_HOME="$BREW/kotlin/libexec"
export CLASSPATH=".:$KOTLIN_HOME/lib/kotlin-stdlib.jar"
export CLASSPATH="$KOTLIN_HOME/lib/kotlin-reflect.jar:$KOTLIN_HOME/lib/kotlin-stdlib-jdk7.jar:$CLASSPATH"
export CLASSPATH="$KOTLIN_HOME/lib/kotlin-jdk8.jar:$KOTLIN_HOME/lib/kotlin-test.jar:$CLASSPATH"
export M2_HOME="$OPT/mvn"
export MAVEN_OPTS="-Xms512m -Xmx1024m"
export GROOVY_HOME="$OPT/groovy"

# others
export VSCODE="/Applications/Visual Studio Code.app/Contents/Resources/app"


# PATH
# 通用工具
INIT_PATH="$HOME/bin:$HOME/tools:/usr/local/bin:/usr/local/sbin"

# BREW安装的工具
INIT_PATH="$INIT_PATH:$BREW/make/libexec/gnubin:$BREW/gnu-sed/libexec/gnubin:$BREW/krb5/bin:$BREW/krb5/sbin"
INIT_PATH="$INIT_PATH:$BREW/python@2/bin"

# 用户级别的python包安装路径: /usr/local/bin/python -m pip install -U <package_name> --user
INIT_PATH="$INIT_PATH:$HOME/Library/Python/2.7/bin"

# 个人工具
# ruby
INIT_PATH="$INIT_PATH:$HOME/.rvm/bin"

# golang
INIT_PATH="$INIT_PATH:$GOROOT/bin:$GOBIN"

# java
INIT_PATH="$INIT_PATH:$JAVA_HOME/bin:$ANT_HOME/bin:$M2_HOME/bin:$GROOVY_HOME/bin"

# 系统自带工具路径
INIT_PATH="$INIT_PATH:/usr/bin:/usr/sbin:/bin:/sbin:$SYS_PATH"

export INIT_PATH
export PATH=${INIT_PATH}:$PATH

# manpath
export MANPATH="$BREW/make/libexec/gnuman:$MANPATH"

# Direnv hook
eval "$(direnv hook zsh)"

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as afunction*

# vg, golang virtualenv
command -v vg >/dev/null 2>&1 && eval "$(vg eval --shell zsh)"

