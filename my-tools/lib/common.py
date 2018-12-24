#!/usr/bin/env python
# _*_ coding: utf-8 _*_
#


def green(s):
    return "\033[32m%s\033[0m" % s


def red(s):
    return "\033[31m%s\033[0m" % s


def yellow(s):
    return "\033[33m%s\033[0m" % s