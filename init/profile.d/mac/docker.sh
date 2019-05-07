#!/usr/bin/env bash

images=(
alpine
centos:6
centos:7
ubuntu:16.04
ubuntu:18.04
pivotaldata/gpdb6-centos6-build
pivotaldata/gpdb6-centos6-test
pivotaldata/gpdb6-centos7-build
pivotaldata/gpdb6-centos7-test
pivotaldata/gpdb6-centos6-dependencies-build
pivotaldata/gpdb6-centos7-dependencies-build
concourse/concourse
)

docker-containers-clean(){
	docker rm -fv $(docker ps -aq -f status=exited)
}

docker-images-clean(){
	docker rmi `docker images | grep "<none>"|awk '{print $3}'`
}

docker-images-pull(){
	for image in ${images}
	do
		echo "pulling $image ............"
		docker pull "$image"
	done
}

docker-mysql(){
	docker run -d \
		--name mysql-server \
		-p 3306:3306 \
		-v ${OPT}/data/mysql:/var/lib/mysql \
		-e MYSQL_ROOT_PASSWORD=19840406 \
		mysql:latest
}

docker-redis(){
	docker run -d \
		--name redis-server \
		-v ${OPT}/data/redis:/data  \
		-p 6379:6379 \
		redis \
		redis-server --appendonly yes
}
