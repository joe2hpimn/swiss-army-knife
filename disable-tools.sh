#!/usr/bin/env zsh

cat $HOME/.zshrc|grep -v 'source \${BASE_DIR}/bin/init/env.sh' > /tmp/zshrc
mv /tmp/zshrc $HOME/.zshrc
