#!/usr/bin/env bash

sql-postgres-fdw-env(){
	# 支持: postgres_fdw, gp2gp_fdw
	name=${1:-postgres}
	sql="
drop table IF EXISTS t1;
drop foreign table IF EXISTS ft1;

drop user mapping IF EXISTS for CURRENT_USER SERVER local_server;
drop server IF EXISTS local_server;
drop extension IF EXISTS ${name}_fdw;

create table t1(i int);
insert into t1 select * from generate_series(1, 1024);

CREATE EXTENSION ${name}_fdw;
CREATE SERVER local_server FOREIGN DATA WRAPPER ${name}_fdw OPTIONS (dbname 'baotingfang');
CREATE USER MAPPING FOR CURRENT_USER SERVER local_server;
CREATE FOREIGN TABLE ft1 (i int) SERVER local_server OPTIONS (table_name 't1');
	"
	g6 && psql -c "${sql}"
}

