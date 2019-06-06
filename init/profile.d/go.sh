#!/usr/bin/env bash
# shellcheck disable=2155,2164

go-tags(){
	gotags -tag-relative=true -R=true -sort=true -f="tags" -fields=+l .
}

go-dep-view(){
	dep status -dot | dot -T png| open -f -a /Applications/Preview.app
}

go-doc(){
	ADDR=127.0.0.1:9999
	ps -ef |grep 'godoc'|grep -v 'grep'|grep "$ADDR" > /dev/null
	if [[ $? -ne 0 ]];then
		nohup godoc -http "$ADDR" > /dev/null 2>&1  &
		echo "started godoc server!"
	fi
	open http://"$ADDR"
}

go-doc-stop(){
	ps -ef |grep 'godoc'|grep -v 'grep'|grep '127.0.0.1'|awk '{print $2}' | xargs kill -9
	echo "stoped all godoc server!"
}

go-envrc(){
	cat << "EOF" > .envrc
export GOPATH=$PWD
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH
EOF

	mkdir pkg src bin
	mkdir -p src/github.com/baotingfang
}

go-tools-update(){
	local cur_dir=`pwd`
	cd ${HOME}/go-projects

	go get -u golang.org/x/tools/cmd/goimports
	go get -u golang.org/x/tools/cmd/gorename
	go get -u github.com/sqs/goreturns
	go get -u github.com/nsf/gocode
	go get -u github.com/alecthomas/gometalinter
	go get -u github.com/zmb3/gogetdoc
	go get -u github.com/rogpeppe/godef
	go get -u golang.org/x/tools/cmd/guru

	cd ${cur_dir}
}

go-ginkgo-init(){
	ginkgo bootstrap
	ginkgo generate
}

go-mod-status(){
	go list -m all | dog
}

go-mod-detail-status(){
	# gem install lolcat
	go list -m -json all | lolcat 
}
