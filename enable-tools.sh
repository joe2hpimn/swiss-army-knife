#!/usr/bin/env zsh

cat $HOME/.zshrc | grep 'source \$HOME/bin/init/env.sh' || echo "source \$HOME/bin/init/env.sh" >> $HOME/.zshrc
source $HOME/.zshrc
