#!/usr/bin/env bash

sql-postgres-fdw-env(){
	sql="
drop table IF EXISTS t1;
drop foreign table IF EXISTS ft1;

drop user mapping IF EXISTS for CURRENT_USER SERVER local_server;
drop server IF EXISTS local_server;
drop extension IF EXISTS postgres_fdw;

create table t1(i int);
insert into t1 select * from generate_series(1, 100);

CREATE EXTENSION postgres_fdw;
CREATE SERVER local_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname 'baotingfang');
CREATE USER MAPPING FOR CURRENT_USER SERVER local_server;
CREATE FOREIGN TABLE ft1 (i int) SERVER local_server OPTIONS (table_name 't1', mpp_execute 'all segments');
	"
	g6 && psql -c "${sql}"
}

