#!/usr/bin/env bash

make_dir() {
  local target_path=$1
  echo "create folder: $target_path"
  mkdir -vp $target_path
}

execute_command() {
  local msg=$1
  local command_to_run="$2"
  echo "[$msg] attempting to run command: '$command_to_run'"
  if [[ -n "$command_to_run" ]]; then
    eval "$command_to_run"
  fi
}

# read "command_entries" (as defined in schemas/cmds.yaml) from yaml file
# returns list of commands to execute, each with arguments (all items in pkgs concatenated)
parse_command_entries_in_yaml() {
  local -n commands=$1
  local yamlcommandfile=$2
  local -n commandslist=$3
  #local commandslist=()
  echo "process file: $2"
  mapfile -d '' commands < <(yq '.command_entries[] | .command' $yamlcommandfile | tr -d '"' | tr '\n' '\0')
  for cmd in "${commands[@]}"
  do
    echo "fetch packages for cmd: $cmd"
    # not easy to use yq with environment variables, workaround with a pipe to jq
    # sed is for trimming trailing space
    pkgs=$(yq '.' $yamlcommandfile | jq --arg buff "$cmd" '.command_entries[] | select(.command == $buff) | .pkgs[]' | tr -d '"' | tr '\n' ' ' | sed 's/[ \t]*$//')
  #yq '.command_entries[] | .command' "$yamlcommandfile" | tr -d '"' | tr '\n' '\0'
    echo "print: $pkgs"
    commandslist+=("${cmd} ${pkgs}")
    #execute_command $1
  done
}

process_commands_in_yamls() {
  local -n yamls_cmds=$1
  #declare -p yamls_cmds
  echo "yamls_cmds size: ${#yamls_cmds[@]}"
  for cmd_file in ${yamls_cmds[@]}; do
    local command_entries
    local commands_list
    #mapfile command_entries < <(parse_command_entries_in_yaml command_entries $cmd_file)
    parse_command_entries_in_yaml command_entries $cmd_file commands_list
    #echo "commands: ${command_entries}"
    declare -p command_entries
    declare -p commands_list
    #execute_command $1
  done
}

find_files_by_extension() {
  local folder_path=$1
  local extension=$2
  # local files=$(find * -name "$folder_path/*.$extension")
  find $folder_path -name "*.$extension" -print0
}

# propagate function to subshells
typeset -fx execute_command
typeset -fx make_dir
typeset -fx find_files_by_extension
typeset -fx process_commands_in_yamls
