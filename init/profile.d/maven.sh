#!/usr/bin/env bash

mvn-create-app(){
	local groupId=$1
	local artifactId=$2

	if [[ -z $1 || -z $2 ]];then
		echo "Usage: mvn-create groupId artifactId"
		return
	fi

	mvn -B archetype:generate \
		-DarchetypeGroupId=org.springframework.boot \
		-DarchetypeArtifactId=spring-boot-sample-simple-archetype \
		-DgroupId=${groupId} \
		-DartifactId=${artifactId}
}

mvn-create-web(){
	local groupId=$1
	local artifactId=$2

	if [[ -z $1 || -z $2 ]];then
		echo "Usage: mvn-create-web groupId artifactId"
		return
	fi

	mvn -B archetype:generate \
		-DarchetypeGroupId=org.springframework.boot \
		-DarchetypeArtifactId=spring-boot-sample-traditional-archetype \
		-DgroupId=${groupId} \
		-DartifactId=${artifactId}
}




