#!/usr/bin/env bash

make_dir() {
  local target_path=$1
  echo "create folder: $target_path"
  mkdir -vp $target_path
}

execute_command() {
  #local args=${@% }
  local n_words_msg=$1
  #echo "attempting whole args: ${args:2:$n_words_msg}"
  echo "attempting whole args: $@"
  echo "attempting n_words_msg: ${n_words_msg}"
  # local msg=${n_words_msg}
  # local msg=${@:2:$n_words_msg}
  # local msg=${@:2:$n_words_msg+2}
  # local msg=${@:2:$n_words_msg}
  local msg=${@% :2:3}
  echo "test12: $@{3}"
  echo "attempting msg: $msg"
  local command_to_run=${@:$n_words_msg+1}
  echo "attempting to run command: '$command_to_run' with '$msg'"
  # eval "$command_to_run"
}

