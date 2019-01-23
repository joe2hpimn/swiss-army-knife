#!/usr/bin/env zsh

BASE_DIR=$(cd `dirname $0`; pwd)
source ${BASE_DIR}/global.sh

cat $HOME/.zshrc|grep -v 'source \${BASE_DIR}/env.sh' > /tmp/zshrc
mv /tmp/zshrc $HOME/.zshrc
