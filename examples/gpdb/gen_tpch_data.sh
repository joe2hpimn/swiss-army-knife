#!/usr/bin/env bash
set -exu

main(){
	# 参看: http://wiki.home:8888/0007.%E6%95%B0%E6%8D%AE%E5%BA%93/06.PostgreSQL/98.pg%E6%80%A7%E8%83%BD%E6%B5%8B%E8%AF%95/00.tpc-h
	local cur_dir=`pwd`
	local SF=${1:-1}

	WB=/home/gpadmin/tpc-h-files/2.17.3/dbgen

	cd ${WB}
	echo "正在生成数据..."
	./dbgen -s ${SF} -f

	echo "重置数据库..."
	dropdb db1
	createdb db1

	echo "正在创建表..."
	psql -f ./dss.ddl db1

	sql="
Copy region FROM '${WB}/region.tbl' WITH DELIMITER AS '|';
Copy nation FROM '${WB}/nation.tbl' WITH DELIMITER AS '|';
Copy part FROM '${WB}/part.tbl' WITH DELIMITER AS '|';
Copy supplier FROM '${WB}/supplier.tbl' WITH DELIMITER AS '|';
Copy customer FROM '${WB}/customer.tbl' WITH DELIMITER AS '|';
Copy lineitem FROM '${WB}/lineitem.tbl' WITH DELIMITER AS '|';
Copy partsupp FROM '${WB}/partsupp.tbl' WITH DELIMITER AS '|';
Copy orders FROM '${WB}/orders.tbl' WITH DELIMITER AS '|';
"
	echo "正在导入数据...."
	psql -c "${sql}" -d db1

	cd "$cur_dir"
}

main "$@"