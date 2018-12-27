#!/usr/bin/env python
# _*_ coding: utf-8 _*_
#

import os
import sys

from lib.gpdb import gp_home
from lib.utils import red

if gp_home:
    evil_path = os.path.join(gp_home, "lib/python")

    if evil_path in sys.path:
        sys.path.remove(evil_path)

try:
    import psutil
except:
    print "请检查: pip install psutil"


def get_all_gpdb_processes():
    master_procs = []
    segment_procs = []

    all_pids = psutil.pids()

    for pid in all_pids:
        p = psutil.Process(pid)

        if p.name().lower() != 'postgres':
            continue

        args = p.cmdline()
        if '--gp_contentid=-1' in args:
            master_procs.append(p)
        elif 'gp_role=utility' in args:
            segment_procs.append(p)

    return sorted(master_procs, key=lambda x: x.pid), sorted(segment_procs, key=lambda x: x.cmdline())


def filter_gpdb_processes(procs):
    ret = []

    exclude_conditions = [
        "logger process",
        "checkpointer process",
        "writer process",
        "wal writer process",
        "stats collector process",
        "ftsprobe process",
        "sweeper process",
        "global deadlock detector process"
    ]

    for p in procs:
        cmdline = p.cmdline()
        skip = False

        for condition in exclude_conditions:
            if condition in cmdline[0]:
                skip = True

        if not skip:
            ret.append(p)

    return ret


def kill_all_processes(procs):
    for p in procs:
        try:
            p.kill()
            print red("Kill %d" % p.pid)
        except Exception as e:
            print e.message
