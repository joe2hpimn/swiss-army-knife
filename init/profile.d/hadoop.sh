#!/usr/bin/env bash

hadoop-start(){
	${HADOOP_PREFIX}/sbin/start-dfs.sh
	${HADOOP_PREFIX}/sbin/yarn-daemon.sh start resourcemanager
	${HADOOP_PREFIX}/sbin/yarn-daemon.sh start nodemanager
}

hadoop-stop(){
	${HADOOP_PREFIX}/sbin/yarn-daemon.sh stop resourcemanager
	${HADOOP_PREFIX}/sbin/yarn-daemon.sh stop nodemanager
	${HADOOP_PREFIX}/sbin/stop-dfs.sh
}
