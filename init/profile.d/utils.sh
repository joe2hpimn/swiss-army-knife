#!/usr/bin/env bash

# 主要用于link git zshrc的配置文件
config-link(){
	configDir="$HOME/bin/config"

	for f in ${configDir}/*
	do
		echo linking ${f}
		target=$HOME/.`basename ${f}`

		ln -s ${f} ${target}
		echo linked to ${target}
	done
}

pass(){
	str=`md5 -q -s "$@"|md5|md5|md5`
	echo ${str:0:20}
	echo ${str:0:8}
}

slides(){
	git clone https://github.com/hakimel/reveal.js > /dev/null 2>&1

	rm -rf $1.html > /dev/null 2>&1

	# -o :输出文件, 可以根据后缀进行判断
	# --toc: 生成TOC
	# -t 使用的引擎, 最好使用revealjs
	# --mathjax: 支持数据公式
	# -s: 生成单个html文件
	# -V: 指定变量
	# 	theme: 这里指定主题:beige, black, blood, league, moon, night, serif, simple, sky, solarized, white
	#	transition: 这里指定幻灯片切换效果: slide, fade, convex, concave, zoom
	# --highlight-style: 语法高亮主题: zenburn, pygments, kate, monochrome, espresso, haddock, tango
	pandoc $1.md -o $1.html  -t revealjs --mathjax -s -V theme=sky -V transition=convex --highlight-style=zenburn \
		--wrap=preserve \
		--columns=1200 \
		--css=my.css

	# open $1.html
}

ppt-create(){
	slides $1 && open $1.html
}

ppt-init(){
	ln -s $HOME/github/reveal.js reveal.js
}

screen-kill(){
	screen -X -S $1 quit
}

vim-func(){
	if [[ -z $1 ]];then
		echo "vim-func func_name"
		return 0
	fi

	file=`type $1 | awk '{print $7}'`
	vim +/$1 ${file}
}

reload-zsh(){
	source ${HOME}/.zshrc
}

csdn-fetch(){
	local cur_dir=`pwd`

	cd $HOME/Downloads/

	now=`date +%Y%m%d%H%M%S`
	name=csdn-${now}.txt
	csdn-download-list > ${name}

	if-on-mac && code ./${name}
	cd ${cur_dir}
}

lang-swith-to(){
	local cur_dir=`pwd`

	echo "support: en_US, zh_CN"
	lang=${1:-en_US}

	export LANG="$lang".UTF-8
	echo "swith to $lang"

	cd ${cur_dir}
}
