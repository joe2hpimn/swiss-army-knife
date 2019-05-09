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
pivotaldata/gpdb6-ubuntu18.04-build
pivotaldata/gpdb6-ubuntu18.04-test
concourse/concourse
)

docker-containers-clean(){
	local force=${1}

	if [[ "${force}" = "-f" ]];then
		# -f, remove all the containers include the running ones.
		docker rm -fv $(docker ps -aq)
	else
		ids=($(docker ps -aq -f status=exited | tr '\n' ' '))
		[[ -n "${ids}" ]] && docker rm -fv ${ids[*]}
	fi
}

docker-images-clean(){
	ids=($(docker images | grep "<none>"|awk '{print $3}'))
	[[ -n "${ids}" ]] && docker rmi ${ids[*]}
}

docker-images-pull(){
	for image in ${images}
	do
		echo "pulling $image ............"
		docker pull "$image"
	done

	docker-images-clean
}

docker-disk-shrink(){
	df -h
	docker system df

	for image_id in $(docker images -q)
	do
		docker run -it -d ${image_id} /bin/sh
	done

	docker system prune -a
	docker system prune --volumes
	df -h
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
