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

# read "command_entries" (as defined in schemas/cmds.yaml) from yaml file
# return list of commands to execute, each with arguments (all items in pkgs concatenated)
parse_yaml_command_entry() {

}

find_files_by_extension() {
  local folder_path=$1
  local extension=$2
  # local files=$(find * -name "$folder_path/*.$extension")
  find $folder_path -name "*.$extension"
}

# propagate function to subshells
typeset -fx execute_command
typeset -fx parse_yaml_command
typeset -fx make_dir
typeset -fx find_files_by_extension

