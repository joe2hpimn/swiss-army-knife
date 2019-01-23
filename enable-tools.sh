#!/usr/bin/env zsh

BASE_DIR=$(cd `dirname $0`; pwd)
source ${BASE_DIR}/global.sh

cat ${HOME}/.zshrc | grep 'source \${BASE_DIR}/env.sh' || echo "source \${BASE_DIR}/env.sh" >> ${HOME}/.zshrc
source ${HOME}/.zshrc

