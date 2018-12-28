#!/usr/bin/env python
# _*_ coding: utf-8 _*_
#
import sys
import os

import optparse


def green(s):
    return "\033[32m%s\033[0m" % s


def red(s):
    return "\033[31m%s\033[0m" % s


def yellow(s):
    return "\033[33m%s\033[0m" % s


def indent(count, str, indent_char='    '):
    return "".join([indent_char * count, str])


def parse_options(description, parser_func):
    usage = "usage: %prog [options]"
    description = description

    parser = optparse.OptionParser(
        description=description, prog=os.path.basename(sys.argv[0]), usage=usage)

    parser_func(parser)

    return parser.parse_args(sys.argv), parser
