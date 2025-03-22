#!/usr/bin/env bash

make_dir() {
  local target_path=$1
  echo "create folder: $target_path"
  mkdir -vp $target_path
}

execute_install_command() {
  local msg=$1
  local command_to_run="$2"
  echo "[$msg] attempting to run command: '$command_to_run'"
  # associative array to store installed packages
  # key: command run to install packages (variable $msg), value: space separated name of packages
  # -n to name ref the associative array passed as argument
  declare -n installed_pkgs=$3
  if [[ -n "$command_to_run" ]]; then
    #eval "$command_to_run"
    # ~(@kv)~: parameter expansion zsh style
    # in the install command crop out: "install", and any option ("-someoption")
    # => basically just keep the packages names
    installed_pkgs[$msg]+=$(echo "$command_to_run" | sed -n "s/^.*${msg} \(install \)\?\(-[a-zA-Z] \)\?//p")
    # return string form of associative array to be used by calling function
    #for akey in "${!installed_pkgs[@]}"
    #do
    #  echo "tests in execute: [content](key: value): (${akey}: ${installed_pkgs[${akey}]})"
    #done
    #old solution:`echo "${installed_pkgs[@]@K}" # expand associative array as string with ~@K~ parameter (might not work the same on all shells, for example zsh)`
    echo "${installed_pkgs[@]@K}"
  fi
}

# validate that model satisfy schema
# $1 is the schema, and $2 the data
validate_model_against_schema() {
  [[ $(pajv -s $1 -d $2 | grep ' valid') ]] && echo "schema validates the data model" || echo "[WARN] schema does NOT validate the data model, please double check the data model"
}

# read "command_entries" (as defined in schemas/cmds.yaml) from yaml file
# returns list of commands to execute, each with arguments (all items in pkgs concatenated)
parse_command_entries_in_yaml() {
  local -n commands=$1
  local yamlcommandfile=$2
  local -n commandslist=$3
  #local commandslist=()
  echo "process file: $yamlcommandfile"
  # pajv -s $BASIC_CONFIGS_DIR/schemas/cmds.yaml -d $yamlcommandfile
  echo "attempt to validate data model: $2"
  validate_model_against_schema $BASIC_CONFIGS_DIR/schemas/cmds.yaml $yamlcommandfile
  mapfile -d '' commands < <(yq '.command_entries[] | .command' $yamlcommandfile | tr -d '"' | tr '\n' '\0')
  for cmd in "${commands[@]}"
  do
    echo "fetch packages for command: $cmd"
    # not easy to use yq with environment variables, workaround with a pipe to jq
    # sed is for trimming trailing space
    pkgs=$(yq '.' $yamlcommandfile | jq --arg buff "$cmd" '.command_entries[] | select(.command == $buff) | .pkgs[]' | tr -d '"' | tr '\n' ' ' | sed 's/[ \t]*$//')
    #yq '.command_entries[] | .command' "$yamlcommandfile" | tr -d '"' | tr '\n' '\0'
    echo "verify string pkgs: $pkgs"
    if [[ "$pkgs" != "null" ]]; then
      commandslist+=("sudo ${cmd} ${pkgs}")
    fi
  done
}

process_commands_in_yamls() {
  local -n yamls_cmds=$1
  #declare -p yamls_cmds
  declare -n installed_pkgs=$2
  echo "yamls_cmds size: ${#yamls_cmds[@]}"
  for cmd_file in "${yamls_cmds[@]}"; do
    local command_entries
    local commands_list
    parse_command_entries_in_yaml command_entries $cmd_file commands_list
  done
  for cmd in "${commands_list[@]}"; do
    execute_install_command "read from yaml" "$cmd" installed_pkgs
  done
}

find_files_by_extension() {
  local folder_path=$1
  local extension=$2
  # local files=$(find * -name "$folder_path/*.$extension")
  find $folder_path -name "*.$extension" -print0
}

# propagate function to subshells
typeset -fx execute_install_command
typeset -fx make_dir
typeset -fx find_files_by_extension
typeset -fx process_commands_in_yamls
