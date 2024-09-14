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
parse_command_entries_from_yaml() {
  echo "process inputs: $1 -- $2"
  #echo "process inputs: $1"
  local -n commands=$1
  local yamlcommandfile=$2
  #yq '.command_entries[] | .command' $yamlcommandfile
  mapfile -d '' commands < <(yq '.command_entries[] | .command' $yamlcommandfile)
  #echo "commands: ${commands[@]}"
  #execute_command $1
}

run_yaml_command_entry() {
  echo "process command file: $1"
  # execute_command $1
}

find_files_by_extension() {
  local folder_path=$1
  local extension=$2
  # local files=$(find * -name "$folder_path/*.$extension")
  find $folder_path -name "*.$extension" -print0
}

# propagate function to subshells
typeset -fx execute_command
typeset -fx run_yaml_command
typeset -fx make_dir
typeset -fx find_files_by_extension

