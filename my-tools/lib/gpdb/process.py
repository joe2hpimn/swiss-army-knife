#!/usr/bin/env python
# _*_ coding: utf-8 _*_
#

import os
import sys
import subprocess
import platform

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

    for p in psutil.process_iter():

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
    def on_terminate(proc):
        print red("killed {} ".format(proc.pid))

    for p in procs:
        if p.pid == os.getpid():
            continue

        p.kill()

    _, alive = psutil.wait_procs(procs, timeout=5, callback=on_terminate)

    if alive:
        print red("Kill failled, left %s" % alive)


def get_open_fds(pid):
    # if platform.system() != 'Darwin':
    #     print red("get_open_fds only support on macOS (depend on lsof command tool)")
    #     exit(-1)

    ret = []
    output = subprocess.check_output(["lsof", "-p", str(pid)])

    if not output:
        return

    lines = output.strip().split('\n')[1:]

    for line in lines:
        row = line.split()
        fd = row[3]
        file_type = row[4]

        if file_type in ['REG', 'FIFO'] and fd not in ['txt', 'mem', 'DEL']:
            ret.append(
                {
                    "fd": fd.replace("u", ""),
                    "type": file_type,
                    "path": row[-1]
                })

    return ret
