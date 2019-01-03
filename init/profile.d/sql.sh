#!/usr/bin/env bash

sql-postgres-fdw-env(){
	count=${1:-1000}
	g6
	dropdb fdb
	createdb fdb

	sql1="
create table t1(i int);
insert into t1 select * from generate_series(1, ${count});
"
	sql2="
drop foreign table IF EXISTS ft1;

drop user mapping IF EXISTS for CURRENT_USER SERVER local_server;
drop server IF EXISTS local_server;
drop extension IF EXISTS postgres_fdw;

CREATE EXTENSION postgres_fdw;
CREATE SERVER local_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname 'fdb');
CREATE USER MAPPING FOR CURRENT_USER SERVER local_server;
CREATE FOREIGN TABLE ft1 (i int) SERVER local_server OPTIONS (table_name 't1', mpp_execute 'all segments');
	"
	psql -c "${sql1}" -d fdb
	psql -c "${sql2}"
}

sql-remote-postgres-fdw-env(){
	count=${1:-1000}
	remote_sql="
drop table IF EXISTS t1;

create table t1(i int);
insert into t1 select * from generate_series(1, ${count});

	"

	g6 && psql -h mdw-b -Ugpadmin -d gpadmin -c "${remote_sql}"

	local_sql="
drop foreign table IF EXISTS ft1;
drop user mapping IF EXISTS for baotingfang SERVER mdw_b_server;
drop server IF EXISTS mdw_b_server;
drop extension IF EXISTS postgres_fdw;

CREATE EXTENSION postgres_fdw;

CREATE SERVER mdw_b_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'mdw-b', port '5432', dbname 'gpadmin');

CREATE USER MAPPING FOR baotingfang
	SERVER mdw_b_server
	OPTIONS (user 'gpadmin', password '');

CREATE FOREIGN TABLE ft1 (i int) SERVER mdw_b_server OPTIONS (table_name 't1', mpp_execute 'all segments');
	"
	g6 && psql -c "${local_sql}"
}

