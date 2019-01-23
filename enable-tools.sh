#!/usr/bin/env zsh

BASE_DIR=$(cd `dirname $0`; pwd)
source ${BASE_DIR}/global.sh

cat ${HOME}/.zshrc | grep 'source \$HOME/toolbox/env.sh' || echo "source \$HOME/toolbox/env.sh" >> ${HOME}/.zshrc
source ${HOME}/.zshrc

