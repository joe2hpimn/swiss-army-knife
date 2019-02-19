#!/usr/bin/env bash

alias gopath='cd $GOPATH'
alias gows='cd $GOPATH/src/github.com/baotingfang'

alias uzsh='source ~/.zshrc'

alias rm='rm -i'
alias gv='govendor'

alias wb='cd ~/workspace'
alias github='cd ~/github'
alias mygithub='open https://github.com/baotingfang'
alias gpcopy-github='open $CWD_PATH'
alias cwd="cd $CWD_PATH"
alias gpdb='cd $WB/gpdb'
alias gpdb4='cd $WB/gpdb4'
alias cd-postgres='cd $WB/postgres'

alias cat='ccat'
alias dog='ccat'
alias lcat='lolcat'
alias be='bundle exec'
alias tb='cd ${BASE_DIR}'
alias demo='tldr'


# for zsh
alias rake='noglob rake'
alias tf='terraform'

# for git
alias git-diff-from-pre-commit='git diff HEAD^!'


alias ggo='ginkgo --trace -cover -compilers=0 --failFast -notify --afterSuiteHook="echo '美好生活由此开始,小贝....:\)'"'
alias ggw='ginkgo watch --depth=0'

# goagent
alias goproxy='export http_proxy=http://127.0.0.1:8087 https_proxy=http://127.0.0.1:8087'
alias disproxy='unset http_proxy https_proxy'

#gpdb
alias kp='kill-postgres'
alias g6="gpdb-source 6"
alias g4="gpdb-source 4"
alias which-gpdb="readlink $WB/gpdb"

# tomcat
alias tomcat-start='${OPT}/tomcat/bin/startup.sh'
alias tomcat-stop='${OPT}/tomcat/bin/shutdown.sh'

# K8S
alias kb='kubectl'

# postgres
# alias pps="ps -ef|grep postgres|grep -v -E (grep|(logger process)|(checkpointer process)|(writer process)|(stats collector process)|(sweeper process)|(ftsprobe process)|(global deadlock detector process))"
alias pps="watch -c -t -n 1 gpdb-ps"
alias kks="gpdb-ps -k"

# golang
alias go-lint="$GOBIN/golangci-lint"

# tmux
alias tm="tmux"
alias tml="tmux list-sessions"
alias tma="tmux attach-session -t"
alias tm0="tmux attach-session -t 0"

# funny
alias weather="curl wttr.in"

# concourse
alias fly-hijack-dev="fly -t gpdb-dev i -u "
alias fly-hijack-prod="fly -t gpdb-prod i -u "
