#!/usr/bin/env bash

function reload-func() {
  default_name=$1
  name=${default_name:-"reload-func"}
  unfunction ${name} && autoload -U ${name}
}
