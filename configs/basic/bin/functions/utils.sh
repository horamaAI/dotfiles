#!/usr/bin/env bash

make_dir() {
  local target_path=$1
  echo "create folder: $target_path"
  mkdir -vp $target_path
}

execute_command() {
  local msg=$1
  local command_to_run="$2 $3"
  echo "attempting to run command: '$command_to_run' using manager: '$msg'"
  eval "$command_to_run"
}

parse_yaml_command() {

}


# propagate function to subshells
typeset -fx execute_command
typeset -fx parse_yaml_command
typeset -fx make_dir
