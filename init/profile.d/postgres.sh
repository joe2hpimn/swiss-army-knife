#!/usr/bin/env bash

kill-postgres(){
	(ps -ef|grep postgres|grep -v grep|grep -v kill-postgres|awk '{print $2}'|xargs kill -9) || true
	rm -rf /tmp/.s.PGSQL.* || true
}

pg-complie(){
	local cur_dir=`pwd`

	PG_DIR="${OPT}/pg"
	DATA_DIR="$PG_DIR/data"
	PG_LOG="$PG_DIR/pg_dev.logs"

	"$PG_DIR/bin/pg_ctl" -D "$DATA_DIR" -l "$PG_DIR/pg_dev.logs" stop || true

	cd ${WB}/postgres
	make install

	OPTION=""

	if [[ $# -ge 1 ]]; then
		OPTION=$1
	fi

	if [[ "${OPT}ION" == "-f" ]]; then
		echo "removing the old data directory....."
		rm -rf "$DATA_DIR" "$PG_LOG"
	fi

	if [[ ! -d ${DATA_DIR} ]]; then
		mkdir ${DATA_DIR} || true
		"$PG_DIR/bin/initdb" "$DATA_DIR"
	fi

	"$PG_DIR/bin/pg_ctl" -D "$DATA_DIR" -l "$PG_LOG" start
}

pg-full-complie(){
	local curdir=`pwd`

	cd ${WB}/postgres

	# 编译需要brew安装的flex和bison
	./configure --prefix=${HOME}/opt/pg --enable-depend --enable-cassert --enable-debug
	make -j8
	make install

	# install extensions
	cd contrib
	make install

	cd ${curdir}
}

pg-init(){
	local curdir=`pwd`

	PG_DIR="${OPT}/pg"
	DATA_DIR="$PG_DIR/data"

	if [[ ! -d ${DATA_DIR} ]]; then
		mkdir ${DATA_DIR} || true
	fi
	rm -rf ${DATA_DIR}/*

	${PG_DIR}/bin/initdb "$DATA_DIR"
	${PG_DIR}/bin/pg_ctl -D ${DATA_DIR} -l "$PG_DIR/pg_dev.logs" stop || true
	${PG_DIR}/bin/pg_ctl -D ${DATA_DIR} -l "$PG_DIR/pg_dev.logs" start

	cd ${cur_dir}
}

pg-start(){
	PG_DIR="${OPT}/pg"
	DATA_DIR="$PG_DIR/data"

	${PG_DIR}/bin/pg_ctl -D ${DATA_DIR} -l "$PG_DIR/pg_dev.logs" start
}

pg-stop(){
	PG_DIR="${OPT}/pg"
	DATA_DIR="$PG_DIR/data"


	${PG_DIR}/bin/pg_ctl -D ${DATA_DIR} -l "$PG_DIR/pg_dev.logs" stop || true
}

pg-restart(){
	pg-stop
	pg-start
}

pg-cmakelists(){
	cat << "EOF" > CMakeLists.txt
cmake_minimum_required(VERSION 3.8)
project(postgres)

set(CMAKE_CXX_STANDARD 11)

# add extra include directories
include_directories(src/include
	src/interfaces/libpq)

# add extra lib directories
# link_directories(/usr/local/lib)

# specify the dependency on an extra library
# target_link_libraries(hello_clion check.a)

file(GLOB_RECURSE SOURCE_FILES src *.c *.h *.cpp)

add_custom_target(build_postgres COMMAND make -C ${postgres_SOURCE_DIR}
												 CLION_EXE_DIR=${PROJECT_BINARY_DIR})


# specify the executable
add_executable(postgres ${SOURCE_FILES})
EOF
}

pg-refresh(){
	local curdir=`pwd`

	cd ${WB}/postgres
	make install && pg-restart

	cd ${cur_dir}
}

pg-master-id(){
	ps -ef|grep "postgres -D"|grep -v grep| awk '{print $2}'
}
