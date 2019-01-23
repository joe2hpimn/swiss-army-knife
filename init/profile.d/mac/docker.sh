#!/usr/bin/env bash

images="
registry:2
concourse/concourse
ubuntu
centos
memcached
redis
mysql
ruby
nginx
golang
postgres
python
"

docker-container-clean(){
	docker rm -fv $(docker ps -aq -f status=exited)
}

docker-disk-shrink(){
	local cur_dir=`pwd`

	cd "${OPT}/docker/"
	/usr/local/bin/qemu-img convert -O qcow2 Docker.qcow2 Docker2.qcow2
	mv Docker2.qcow2 Docker.qcow2
	echo "done!"

	cd ${cur_dir}
}

docker-disk-size(){
	local cur_dir=`pwd`

	cd "${OPT}/docker/"
	du -sh ./Docker.qcow2

	cd ${cur_dir}
}

docker-images-clean(){
	docker rmi `docker images | grep "^<none>"|awk '{print $3}'` > /dev/null 2>&1
}

docker-images-sync(){
	for image in ${images}
	do
		echo ""
		echo "pulling $image ............"
		docker pull "$image"

		# echo ""
		# echo "push $image to docker-registry............"
		# tag="docker-registry.home:5000/$image"

		echo ""
		echo "TAG: $tag"
		# docker tag "$image" "$tag"
		# docker push "$tag"
		# docker rmi "$tag"
	done
}

docker-images-restore(){
	for image in ${images}
	do
		echo ""
		echo "pulling $image ............"
		name="docker-registry.home:5000/$image"
		docker pull "$name"
		docker tag "$name" "$image"
		docker rmi "$name"
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

docker-registry(){
	local cur_dir=`pwd`
	# docker run -d -p 5000:5000 --name docker-registry -v /Users/baotingfang/opt/docker/var/:/var/lib/registry registry:2
	# echo "docker registry started"

	# echo "pulling registry:2 image...."
	# docker pull registry:2
	# echo "Got Registry:2 Image [done]"

	cd "${OPT}/docker/instances/docker-registry/"
	docker-compose  $*
	echo "docker-registry done!"

	cd ${cur_dir}
}

docker-search(){
	curl https://docker-registry.home:5000/v2/_catalog -k | jq

	if [[ -n "$1" ]];then
		curl https://docker-registry.home:5000/v2/$1/tags/list -k | jq
	fi
}

docker-vm-enter(){
	screen ${HOME}/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
}
