#!/usr/bin/env python
# _*_ coding: utf-8 _*_
#
# Author: Bao Tingfang <mantingfangabc@163.com>
# Author: Bao Tingfang <bbao@pivotal.io>
# DateTime: 2018-11-23 13:26
#

"""
pip install psycopg2-binary
"""
import psycopg2

conn = None

# 指定叶子分区的数量, 默认10000个分区
partition_count = 10000

# 指定每个叶子分区中的记录的行数, 默认是1000
partition_leaf_table_rows = 1000


def create_table():
    global conn
    create_table_sql = """
CREATE TABLE public.users (id int, value int)
DISTRIBUTED BY (id)
PARTITION BY RANGE (id)
( START (1) END (%d) EVERY (1),
  DEFAULT PARTITION extra );
    """ % (partition_count + 1)

    cur = conn.cursor()
    cur.execute(create_table_sql)
    conn.commit()
    print "create table done!"


def generate_data():
    global conn
    cur = conn.cursor()
    tups = []

    # 为了给default 分区插数据, 这里才 +2的.
    for id in range(1, partition_count + 2):
        for row in range(1, partition_leaf_table_rows + 1):
            tup = (id, row)
            tups.append(tup)

        # 准备好500个表的数据, 一次性插入, 效率更高一些!
        if id % 500 == 0:
            args_str = b','.join(cur.mogrify("(%s, %s)", x) for x in tups)
            cur.execute("INSERT INTO public.users VALUES " + args_str)
            conn.commit()
            tups = []
            print "import rows done, table_id=%d" % id

    if tups:
        args_str = b','.join(cur.mogrify("(%s, %s)", x) for x in tups)
        cur.execute("INSERT INTO public.users VALUES " + args_str)
        conn.commit()


if __name__ == '__main__':
    conn = psycopg2.connect(database="gpadmin",
                            user="gpadmin",
                            host="mdw", port="5432")
    create_table()
    generate_data()

    conn.close()
