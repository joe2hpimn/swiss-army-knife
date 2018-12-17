#!/usr/bin/env python
# _*_ coding: utf-8 _*_
#

import optparse
import shlex

import lldb
from btf.plantree import convert_plan_tree


def create_pp_options():
    usage = "usage: %prog [options] node"
    description = '''This command show the plan tree'''

    parser = optparse.OptionParser(
        description=description, prog='pp', usage=usage)
    parser.add_option('-f', '--format', type="string",
                      dest="format", default="plain",
                      help="support format: json,png")

    return parser


# noinspection PyUnusedLocal
def lldb_pp(debuger, command, exe_ctx, result, internal_dict):
    command_args = shlex.split(command)
    parser = create_pp_options()
    try:
        (options, args) = parser.parse_args(command_args)
    except RuntimeError:
        result.SetError("option parsing failed")
        return

    if options.format not in ["plain", "json", "png", "good_json"]:
        result.SetError("support format(-f): json, good_json, png, plain")
        return

    ci = debuger.GetCommandInterpreter()
    output = lldb.SBCommandReturnObject()

    if not args or len(args) > 1:
        result.SetError("usage: pp -f json|good_json|png|plain <object>")
        return

    target = args[0]
    if options.format == 'plain':
        cmd = "po pretty_format_node_dump(nodeToString(%s))" % target
    else:
        cmd = "po nodeToString(%s)" % target

    ci.HandleCommand(cmd, output)
    out = output.GetOutput()

    if out is None:
        print "no object: pp target"
        return

    out = out.strip("\n").strip('"')
    if options.format not in ['plain']:
        out = convert_plan_tree(out, options.format)

    print out.replace("\\n", "\n") if out is not None else ""
