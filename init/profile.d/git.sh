#!/usr/bin/env bash

#git duet
export GIT_DUET_SECONDS_AGO_STALE=30

sourceFiles=("*.c" "*.h" "*.py" "*.cpp" "*.java" "*.go")

# 需要提前安装gogs
git-server-start() {
	local cur_dir=`pwd`

	cd "${OPT}/gogs"

	ps -ef|grep mysqld|grep -v grep

	if [[ $? != 0 ]];then
		echo "Not Started mysql"
		brew services start mysql
		sleep 2
	fi

	nohup ./gogs web>gogs.log 2>&1 &
	open http://git.skyfree.home:3000/

	cd ${cur_dir}
}

git-server-stop() {
	ps -ef|grep gogs|grep -v 'grep'|awk '{print $2}'|xargs kill -9

	ps -ef|grep -v grep | grep mysqld

	if [[ $? == 0 ]];then
		brew services stop mysql
	fi
}

git-branch-clean(){
	git branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d
}



# 统计每个源文件的行数
git-stat-file-count(){
	git ls-files ${sourceFiles} | xargs wc -l
}

# 统计源代码行数
git-total-count(){
	git ls-files ${sourceFiles} | xargs cat | wc -l
}

# 获取git别名列表
git-aliases(){
	git config --get-regexp alias
}

# 统计每个用户的commit数量
git-stat-author-commit(){
	git shortlog --numbered --summary
}

git-reset-submodules(){
	local cur_dir=`pwd`

	if [[ ! -d ".git" ]]; then
		echo "Not a git repo!"
		return
	fi
	# rm -rf gpAux/extensions/googletest
	git submodule deinit --all --force
	git submodule update --init --recursive

	cd ${cur_dir}
}

# 打开远程git repo
opengit(){
	local arg1=$1
	local arg2=$2

	name=${arg1:-"origin"}
	branch=${arg2:-"master"}

	giturl=`git config --get remote.$name.url`
	if [[ "$giturl" == "" ]]
	then
		echo "Not a git repository or no remote.origin.url set"
		return
	fi

	giturl=${giturl/git\@github\.com\:/https://github.com/}
	if [[ -n ${branch} ]];then
	    giturl=${giturl%.git}/tree/${branch}
	fi
	kernel=$(uname -s)

	echo ${giturl}
	if [[ "$kernel" == "Darwin" ]]; then
			open ${giturl}
	else
		xdg-open ${giturl}
	fi
}

git-repos-pull(){
	local cur_dir=`pwd`
	local GIT_REPOS_SYNC="$HOME/.git-repos-sync"

	if [[ -f "${GIT_REPOS_SYNC}" ]]; then
		for repo in `cat "${GIT_REPOS_SYNC}"`
		do
			abs_path_repo=`python -c "import os; print os.path.expanduser('${repo}')"`

			[[ ! -d ${abs_path_repo} ]] && continue
			echo "git pull for ${repo}"
			cd ${abs_path_repo} && git br | grep '*' && git pull
		done
	fi

	cd ${cur_dir}
}
