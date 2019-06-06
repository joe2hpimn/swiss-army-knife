#!/usr/bin/env bash

alias ls='ls -G'
alias ll='ls -alF'

alias cd-commandlinetools='cd $(xcode-select -p)'
alias reset-system-c-headers=" sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_*.pkg -target /"
alias lldb='PATH=/usr/bin:$PATH /usr/bin/lldb'
alias gdb-gpdb='lldb-gpdb'

# brew
alias bup="brew-upgrade"

alias zoom-open="open https://pivotal.zoom.us/my/baotingfang"
alias zoom-show="echo https://pivotal.zoom.us/my/baotingfang"

alias bye-go-home="concourse-status-releng"