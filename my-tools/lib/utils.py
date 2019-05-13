#!/usr/bin/env python
# _*_ coding: utf-8 _*_
#
import sys
import os

import argparse


def green(s):
    return "\033[32m%s\033[0m" % s


def red(s):
    return "\033[31m%s\033[0m" % s


def yellow(s):
    return "\033[33m%s\033[0m" % s


def indent(count, str, indent_char='    '):
    return "".join([indent_char * count, str])


class StoreDict(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        kv = {}
        if not isinstance(values, (list,)):
            values = (values,)
        for value in values:
            n, v = value.split('=')
            kv[n] = v
        setattr(namespace, self.dest, kv)


class MultiValues(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        setattr(namespace, self.dest, values.split(" "))


def parse_options(description, parser_func):
    description = description

    parser = argparse.ArgumentParser(
        description=description, prog=os.path.basename(sys.argv[0]))

    parser_func(parser)

    options = parser.parse_args()

    return options, parser
