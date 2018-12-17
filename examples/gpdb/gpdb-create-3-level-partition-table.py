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

start_year = 2011
end_year = 2013


def create_p3_sales():
    global conn
    create_table_sql = """
DROP TABLE IF EXISTS public.p3_sales;
CREATE TABLE public.p3_sales (id int, year int, month int, day int, region text)
DISTRIBUTED BY (id)
PARTITION BY RANGE (year)
    SUBPARTITION BY RANGE (month)
    SUBPARTITION TEMPLATE (
        START (1) END (13) EVERY (1),
        DEFAULT SUBPARTITION other_months )

    SUBPARTITION BY LIST (region)
    SUBPARTITION TEMPLATE (
        SUBPARTITION usa VALUES ('usa'),
        SUBPARTITION asia VALUES ('asia'),
        DEFAULT SUBPARTITION other_regions)
( START (%d) END (%d) EVERY (1),
DEFAULT PARTITION outlying_years );
    """ % (start_year, end_year + 1)

    cur = conn.cursor()
    cur.execute(create_table_sql)
    conn.commit()


def generate_data():
    global conn
    cur = conn.cursor()

    result = []
    tups = []
    id = 0
    for year in range(start_year, end_year):
        for month in range(1, 14):
            for region in ['usa', 'asia', 'xxx']:
                tup = (id, year, month, region)
                tups.append(tup)
                id += 1

    args_str = b','.join(cur.mogrify("(%s, %s, %s, 100, %s)", x) for x in tups)
    cur.execute("INSERT INTO public.p3_sales VALUES " + args_str)

    print(len(result))
    conn.commit()


if __name__ == '__main__':
    conn = psycopg2.connect(database="gpadmin",
                            user="gpadmin",
                            host="mdw", port="5432")
    create_p3_sales()
    generate_data()

    conn.close()
