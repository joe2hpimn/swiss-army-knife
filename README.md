# My ToolBox on Mac/Linux

## 1. How to Init

MAC

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install git curl wget golang zsh

# install oh-my-zsh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 

$ cd ~ && git clone https://github.com/baotingfang/swiss-army-knife.git toolbox
$ cd ~/toolbox && ./install-my-tools
```

Ubuntu

```bash
$ sudo apt update && apt install -y git curl wget golang zsh

# install oh-my-zsh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 

$ cd ~ && git clone https://github.com/baotingfang/swiss-army-knife.git toolbox 
$ cd ~/toolbox && ./install-my-tools
```

## 2. How to compile gpdb6

```bash
$ cd ~/workspace
$ git clone git@github.com:greenplum-db/gpdb.git
$ cd ~/workspace/gpdb/
$ gpdb-full

```

