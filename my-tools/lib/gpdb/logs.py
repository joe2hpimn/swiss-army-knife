#!/usr/bin/env python
# _*_ coding: utf-8 _*_
#
import datetime
import glob
import csv

from lib.utils import *
from lib.gpdb import gp_home

if not gp_home:
    print "Please source gpdb: g6 / g4"
    exit(-1)


def get_the_latest_master_log_file():
    master_dir = os.environ.get("MASTER_DATA_DIRECTORY")
    master_logs = os.path.join(master_dir, "pg_log/gpdb-*")

    files = glob.glob(master_logs)
    if not files:
        print "Not Found any log files"
        exit(-2)

    files.sort(key=lambda f: os.path.getmtime(f))

    return files[-1]


def get_the_latest_segment_log_file(seg_id=0):
    seg_dir = os.environ.get("GPDB_DATA_DIR")
    seg_logs = os.path.join(seg_dir, "gpdata/gpsne%d/pg_log/gpdb-*" % seg_id)

    files = glob.glob(seg_logs)
    if not files:
        print "Not Found any log files"
        exit(-2)

    files.sort(key=lambda f: os.path.getmtime(f))

    return files[-1]


def output_logs(file_path, show_level="ALL", before_min=5):
    now = datetime.datetime.now()
    with open(file_path) as f:
        reader = csv.reader(f)
        for r in reader:
            log_time = datetime.datetime.strptime(r[0], "%Y-%m-%d %H:%M:%S.%f CST")
            if (now - log_time).seconds < before_min * 60:
                _output_log(r, show_level)


def _output_log(log, show_level="ALL"):
    level = log[16]

    if show_level != 'ALL' and show_level.lower() != level.lower():
        return

    level = red(log[16]) if log[16].lower() in ["error"] else green(log[16])

    print """
%s
    User: %s  DB: %s  SEG: %s  
    LEVEL: %s  
    MSG: %s
    SQL: %s
    file: %s :line: %s""" % (log[0], log[1], log[2], log[11], level, log[18], log[23], log[27], log[28])
