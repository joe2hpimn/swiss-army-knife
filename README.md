# My ToolBox on Mac/Linux

# How to Init

MAC

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install git curl wget golang zsh

# install oh-my-zsh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
$ rm ~/.zshrc

$ cd ~ && git clone https://github.com/baotingfang/swiss-army-knife.git bin
$ cd bin && install-my-tools
```

Ubuntu

```bash
$ sudo apt update && apt install -y git curl wget golang zsh

# install oh-my-zsh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
$ rm ~/.zshrc

$ cd ~ && git clone https://github.com/baotingfang/swiss-army-knife.git bin
$ cd bin && install-my-tools
```
