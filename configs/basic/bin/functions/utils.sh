#!/usr/bin/env bash

make_dir() {
  local target_path=$1
  echo "create folder: $target_path"
  mkdir -vp $target_path
}

execute_command() {
  local msg=$1
  local command_to_run="$2 $3"
  echo "attempting to run command: '$command_to_run' with '$msg'"
  # eval "$command_to_run"
}

