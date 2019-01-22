#!/usr/bin/env zsh

cat $HOME/.zshrc|grep -v 'source \$HOME/bin/init/env.sh' > /tmp/zshrc
mv /tmp/zshrc $HOME/.zshrc
