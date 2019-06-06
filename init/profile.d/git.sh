#!/usr/bin/env bash
# shellcheck disable=2155,2164,2128,2063

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

	local name=${arg1:-"origin"}
	local branch=${arg2:-"master"}

	local git_url=$(git config --get remote.${name}.url)
	if [[ "$git_url" == "" ]]
	then
		echo "Not a git repository or no remote.origin.url set"
		return
	fi

	git_url=${git_url/git\@github\.com\:/https://github.com/}
	if [[ -n ${branch} ]];then
	    git_url=${git_url%.git}/tree/${branch}
	fi
	kernel=$(uname -s)

	echo ${git_url}
	if [[ "$kernel" == "Darwin" ]]; then
			open ${git_url}
	else
		xdg-open ${git_url}
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
			cd "${abs_path_repo}" && git br | grep '*' && git pull
		done
	fi

	cd ${cur_dir}
}

git-help-diff(){
	echo "
# 比较当前分支, 与master分支的不同

	git diff master

# 比较当前分支, 与master分支修改的文件状态

	git diff --name-status master
	git diff --name-only master

# 比较任意两个分支的不同, 比如master分支和staging分支

	git diff master..staging

# 比较任意两个分支的文件修改状态

	git diff --name-status master..staging
	git diff --name-only master..staging

# 比较同一个文件, 在两个不同分支上的变化

	git diff branch1 master -- myfile.c
	git diff branch1..master -- myfile.c

# 比较当前工作区的文件, 与master分支上的同名文件的变化

	git diff ..master -- myfile.c

"
}
