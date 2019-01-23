#!/usr/bin/env zsh

cat $HOME/.zshrc | grep 'source \${BASE_DIR}/bin/init/env.sh' || echo "source \${BASE_DIR}/bin/init/env.sh" >> $HOME/.zshrc
source $HOME/.zshrc

