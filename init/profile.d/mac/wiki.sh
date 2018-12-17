#!/usr/bin/env bash

note-commit(){
	local cur_dir=`pwd`

	msg=${1:-none}
	echo ${msg}

	cd $HOME/wiki
	find . -name .DS_Store |xargs rm {}\;
	git add -A
	git commit -m ${msg}

	cd ${cur_dir}
}

note-backup(){
	local cur_dir=`pwd`

	now=`date +%Y%m%d%H%M%S`

	cd $HOME/share_bak
	name=note-${now}.tar.gz
	tar -cvzf ${name} $HOME/wiki
	echo "done: bak_name: $name"

	cd ${cur_dir}
}

annotation-backup(){
	local cur_dir=`pwd`

	now=`date +%Y%m%d%H%M%S`

	cd $HOME/projects/understand/gpdb/
	cp ./baotingfang-gpdb.ann "$HOME/share_bak/${now}-baotingfang-gpdb.ann"

	echo "annotation backup done!"
	cd ${cur_dir}
}

note-count(){
	local cur_dir=`pwd`

	cd $HOME/wiki
	find . -name "*.md" | wc -l

	cd ${cur_dir}
}

wiki-start(){
	local cur_dir=`pwd`

	ps -ef|grep gollum|grep -v 'grep' |awk '{print $2}'|xargs kill -9


	# --show-all, --base-path doc
	# --adapter rugged \
		# --no-edit \
		# --live-preview

	source $HOME/.rvm/scripts/rvm
	rvm use 2.4.1@wiki

	cd $HOME/wiki/
	nohup gollum --host 0.0.0.0 \
		--port 8888 \
		--ref master \
		--no-edit \
		--show-all \
		--adapter rugged \
		--show-all \
		--collapse-tree > /dev/null 2>&1 &


	#   gollum --host 0.0.0.0 \
		#   	--port 8888 \
		#   	--ref master \
		#   	--live-preview \
		#   	--adapter rugged \
		#   	--show-all \
		#   	--collapse-tree
	cd ${cur_dir}

	open http://wiki.home:8888/pages/
}

wiki-stop(){
	ps -ef|grep gollum|grep -v 'grep' |awk '{print $2}'|xargs kill -9
	ps -ef|grep wiki-start|grep -v 'grep' |awk '{print $2}'|xargs kill -9

	echo "stopped"
}

wiki-pivotal-sync(){
	local cur_dir=`pwd`

	rm -r $HOME/workspace/cn-wiki/

	cd $HOME/workspace/cn-wiki

	cp -R $HOME/wiki/0000.Pivotal/* .
	git add -A
	git commit -m "sync operation: `now`"
	git push

	cd ${cur_dir}
}