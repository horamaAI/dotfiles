#!/usr/bin/env bash

make_dir() {
  local target_path=$1
  echo "create folder: $target_path"
  mkdir -vp $target_path
}

execute_install_command() {
  local msg=$1
  local command_to_run="$2"
  # reference to 'INSTALLED_APPS', used to keep trace of installed packages,
  # (see 'profiles/basic/basic.h')
  # - key: $msg, command used to install packages
  # - value: space separated name of packages
  # "-n" used to name ref the associative array passed as argument
  declare -n installed_pkgs=$3
  echo "[$msg] attempting to run command: '$command_to_run'"
  if [[ -n "$command_to_run" ]]; then
    #eval "$command_to_run"
    # crop "install" and any option ("-someoption"),
    # i.e.: basically just keep the packages names (space separated)
    installed_pkgs[$msg]+=$(echo "$command_to_run" | sed -n "s/^.*${msg} \(install \)\?\(-[a-zA-Z] \)\?//p")
    # [TO_DELETE] after use, temporary cheap solutions used when debugging
    #for akey in "${!installed_pkgs[@]}"
    #do
    #  echo "tests in execute: [content](key: value): (${akey}: ${installed_pkgs[${akey}]})"
    #done
    echo "${installed_pkgs[@]@K}" # just info log, not return value
  fi
}

# validate that model satisfies schema
# $1 is the schema, and $2 the data
# eg: "pajv -s $BASIC_CONFIGS_DIR/schemas/cmds.yaml -d $yamlcommandfile"
validate_model_against_schema() {
  [[ $(pajv -s $1 -d $2 | grep ' valid') ]] && echo "schema validates the data model" || echo "[WARN] schema does NOT validate the data model, please double check the data model"
}

# reads and stores fields from yaml file, 'command_entries'/:
# - 'command'; - 'pkgs'; - 'command_for_test'
# Here, we suppose yaml has been validated by
# schema definition (eg: schemas/cmds.yaml)
parse_command_entries_in_yaml() {
  local yamlcommandfile=$1
  local -n final_commands_list_=$2
  # ~local -n 'commands_tests' is an associative array of yaml
  # fields: [.command, .command_for_test]; 'command_for_test' can be empty
  local -n commands_tests=$3
  echo "process file: $yamlcommandfile"
  echo "first, attempt to validate that data is valid per model: $1"
  validate_model_against_schema $BASIC_CONFIGS_DIR/schemas/cmds.yaml $yamlcommandfile
  # parse yaml files
  # fetch '.command' and '.command_for_test' if exists
  # first log outputs of yq, before storing the result
  yq '.' $yamlcommandfile | jq --arg buff '' '.command_entries[] | "[" + (.command | @sh) + "]=" + (.command_for_test // $buff | @sh)' | tr -d \"
  echo "====>> holly sun ghost"
  local -A buffer="($(yq '.' $yamlcommandfile | jq --arg buff '' '.command_entries[] | "[" + (.command | @sh) + "]=" + (.command_for_test // $buff | @sh)' | tr -d \"))"
  for key in "${!buffer[@]}"
  do
    # log before storing
    echo "buff key-value: [/$key/]: (${buffer[$key]})"
    commands+=$key
    commands_tests[$key]+=${buffer[$key]}
  done
  local commands=()
  for cmd in "${commands[@]}"
  do
    echo "fetch packages to install for command: $cmd"
    # get pkgs of command_entries '$cmd',
    # i.e.: .command_entries[command=$cmd]/pkgs[]
    # not easy to use yq with environment variables,
    # did a workaround with a pipe to jq.
    # sed is only used here to trim trailing space
    pkgs=$(yq '.' $yamlcommandfile | jq --arg buff "$cmd" '.command_entries[] | select(.command == $buff) | .pkgs[]' | tr -d '"' | tr '\n' ' ' | sed 's/[ \t]*$//')
    echo "verify string pkgs: $pkgs"
    if [[ "$pkgs" != "null" ]]; then
      final_commands_list_+=("sudo ${cmd} ${pkgs}")
    fi
  done
}

process_commands_in_yamls() {
  local -n yamls_cmds_files_=$1
  declare -n installed_pkgs=$2
  declare -n installed_apps_test_cmds=$3
  echo "yamls_cmds_files size: ${#yamls_cmds_files_[@]}"
  for cmd_file in "${yamls_cmds_files_[@]}"; do
    local final_commands_list
    parse_command_entries_in_yaml $cmd_file final_commands_list installed_apps_test_cmds
  done
  for cmd in "${final_commands_list[@]}"; do
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
