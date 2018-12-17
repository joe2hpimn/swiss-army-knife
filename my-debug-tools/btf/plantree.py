#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import json
import uuid
import os

# should include the import command
# noinspection PyUnresolvedReferences
from translator import *

TRANSLATE_OPTION = False


def get_token_value(value):
    value_str = value.strip("{(:)}\"").strip()

    if value_str == '<>' or value_str == '':
        return None
    try:
        int_value = int(value_str)
        return int_value
    except ValueError:
        pass

    try:
        float_value = float(value_str)
        return float_value
    except ValueError:
        pass

    if value_str in ['true', 'false']:
        return True if value_str.lower() == 'true' else False
    return value_str


def get_effective_tokens(start_flag, rest_tokens, include_self=False):
    str_value = ' '.join(rest_tokens)
    effective_tokens = find_matcher(str_value, start_flag).split()
    return effective_tokens if include_self else effective_tokens[1:]


def unwrapper_tokens(tokens):
    ret = []
    if not tokens:
        return []

    if len(tokens) == 1:
        ret.append(tokens[0][1: -1])
    else:
        ret.append(tokens[0][1:])
        ret.extend(tokens[1:-1])
        ret.append(tokens[-1][0:-1])

    return ret


def transfer(tokens, is_list=False):
    if is_list:
        assert tokens[0][0] == '('
        tokens = unwrapper_tokens(tokens)
        ret = []
    else:
        ret = {}

    skip_token_count = 0

    for i, token in enumerate(tokens):
        if skip_token_count > 0:
            skip_token_count -= 1
            continue

        next_token = tokens[i + 1] if i < len(tokens) - 1 else ""
        token_value = get_token_value(token)
        next_token_value = get_token_value(next_token)

        if token.startswith("{"):
            current_tokens = get_effective_tokens('{', tokens[i:])
            skip_token_count = len(current_tokens)
            if isinstance(ret, list):
                ret.append({
                    token_value: transfer(current_tokens)
                })
            else:
                ret[token_value] = transfer(current_tokens)
        elif token.startswith(":"):
            if next_token[0] not in '({:':
                global TRANSLATE_OPTION
                if TRANSLATE_OPTION:
                    ret[token_value] = translate_option(
                        token_value, next_token_value, next_token_value)
                else:
                    ret[token_value] = next_token_value
            elif next_token.startswith('('):
                ret[token_value] = []
                current_tokens = get_effective_tokens('(', tokens[i:], True)
                skip_token_count = len(current_tokens)
                child = transfer(current_tokens, True)
                ret[token_value].extend(child)
            elif next_token.startswith('{'):
                current_tokens = get_effective_tokens('{', tokens[i:], True)
                skip_token_count = len(current_tokens)
                ret[token_value] = transfer(current_tokens)
        else:
            if is_list:
                ret.append(token_value)

    return ret


def find_matcher(str_value, start_flag='{'):
    flag_set = '{}'
    wrapper = "{%s}"

    if start_flag == '(':
        flag_set = '()'
        wrapper = "(%s)"

    if start_flag in str_value:
        match = str_value.split(start_flag, 1)[1]

        flag = 1
        for index in xrange(len(match)):
            if match[index] in flag_set:
                flag = (flag + 1) if match[index] == start_flag else (flag - 1)

            if not flag:
                return wrapper % match[:index]


def travel(root, parent_node_id, parent_note):
    node_id = uuid.uuid4()
    if root is None:
        return []

    ret = []
    name = None
    for _, option_name in enumerate(root):
        name = option_name

    value = root.get(name)
    note = translate_option("%s_note" % name, value, None)
    note = "%s (%s)" % (name, note) if note else name

    ret.append("%s(\"%s\") --> %s(\"%s\")" %
               (parent_node_id, parent_note, node_id, note))
    ret.extend(travel(root.get(name).get('lefttree'), node_id, note))
    ret.extend(travel(root.get(name).get('righttree'), node_id, note))

    return ret


def find_plantree_node(obj, key):
    if key in obj:
        return obj[key]

    for _, v in obj.items():
        if isinstance(v, dict):
            return find_plantree_node(v, key)


def convert_plan_tree(str_value, format_option):
    global TRANSLATE_OPTION
    TRANSLATE_OPTION = False

    if format_option in ['good_json', 'png']:
        TRANSLATE_OPTION = True

    all_tokens = str_value.strip("\n").strip('"').split(' ')

    if not all_tokens:
        return ""

    is_list = True if all_tokens[0][0] == '(' else False

    converted_tokens = transfer(all_tokens, is_list)

    if format_option in ['json', 'good_json']:
        return json.dumps(converted_tokens, sort_keys=True)
    elif format_option == "png":
        if not isinstance(converted_tokens, dict):
            return "Please provide a node object!"

        plan_tree = find_plantree_node(converted_tokens, 'planTree')

        if not plan_tree:
            return "the object must be include planTree attribute!"

        data = ["graph TD"]
        data.extend((travel(plan_tree, "root", "root")))

        content = '\n'.join(data)
        work_dir = "%s/tmp" % os.getenv("HOME", "/tmp")

        with open("%s/node_tree.mmd" % work_dir, "w") as mmd_file:
            mmd_file.write(content)

        status = os.system(
            "export PATH=/usr/local/bin:/bin:/usr/bin:$PATH; "
            "cd %s; "
            "rm -f node_tree.png | true;"
            "mmdc -i node_tree.mmd  -o node_tree.png; "
            "open node_tree.png;"
            "rm -f node_tree.mmd | true;" % work_dir)

        if status != 0:
            print "generate the png error!!!!"

        return json.dumps(converted_tokens, sort_keys=True)


def translate_option(name, value, default_value):
    try:
        text_value = eval("translate_%s" % name.lower())(value)
        return text_value
    except NameError:
        return default_value


if __name__ == '__main__':
    with open("example2.txt", "r") as f:
        raw_string = f.read()
    print convert_plan_tree(raw_string, 'good_json')

    json_data = convert_plan_tree(raw_string, 'png')
    print json_data

    with open("a.json", "w") as out:
        out.write(json_data)
