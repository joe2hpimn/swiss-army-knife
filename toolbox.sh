#!/usr/bin/env bash

enable-my-tool-box(){
	cat $HOME/.zshrc | grep 'source \$HOME/bin/init/env.sh' || echo "source \$HOME/bin/init/env.sh" >> $HOME/.zshrc
	source $HOME/.zshrc
}

disable-my-tools-box(){
	cat $HOME/.zshrc|grep -v 'source \$HOME/bin/init/env.sh' > /tmp/zshrc
	mv /tmp/zshrc $HOME/.zshrc
	source $HOME/.zshrc
}
