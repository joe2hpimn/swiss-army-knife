#!/usr/bin/env python
# _*_ coding: utf-8 _*_


def _try_get_value(name, value):
    if isinstance(value, dict):
        return value.get(name)
    else:
        return value


def which_choice(index, choices):
    try:
        return choices[index]
    except:
        return None


def translate_motion_note(value):
    if isinstance(value, int):
        return translate_motiontype(value)
    else:
        return _try_get_value("motionType", value)


def translate_motiontype(value):
    all_types = [
        "MOTIONTYPE_HASH",
        "MOTIONTYPE_FIXED",
        "MOTIONTYPE_EXPLICIT"]

    index = _try_get_value("motionType", value)

    return which_choice(index, all_types)


def translate_flotype(value):
    all_types = [
        "FLOW_UNDEFINED",
        "FLOW_SINGLETON",
        "FLOW_REPLICATED",
        "FLOW_PARTITIONED"]

    index = _try_get_value("flotype", value)

    return which_choice(index, all_types)


def translate_locustype(value):
    all_types = [
        "CdbLocusType_Null",
        "CdbLocusType_Entry",
        "CdbLocusType_SingleQE",
        "CdbLocusType_General",
        "CdbLocusType_SegmentGeneral",
        "CdbLocusType_Replicated",
        "CdbLocusType_Hashed",
        "CdbLocusType_HashedOJ",
        "CdbLocusType_Strewn",
        "CdbLocusType_End"

    ]

    index = _try_get_value("locustype", value)

    return which_choice(index, all_types)


def translate_commandtype(value):
    all_types = [
        "CMD_UNKNOWN",
        "CMD_SELECT",
        "CMD_UPDATE",
        "CMD_INSERT",
        "CMD_DELETE",
        "CMD_UTILITY",
        "CMD_NOTHING",

    ]

    index = _try_get_value("commandType", value)

    return which_choice(index, all_types)


def translate_aggstrategy(value):
    all_types = [
        "AGG_PLAIN",
        "AGG_SORTED",
        "AGG_HASHED",
    ]

    index = _try_get_value("aggstrategy", value)

    return which_choice(index, all_types)
