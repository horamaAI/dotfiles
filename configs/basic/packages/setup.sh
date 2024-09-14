#!/usr/bin/env bash

COMMENT=\#*

process_yaml_commands() {
  local yamls_cmds=$1
  for cmd_file in ${yamls_cmds[@]}; do
    local command_entries
    parse_command_entries_from_yaml command_entries $cmd_file
    #parse_command_entries_from_yaml $cmd_file
    echo "commands: ${command_entries}"
    declare -p command_entries
    # run_yaml_command_entry $cmd_file
  done
}

declare -a yamls_cmds
mapfile -d '' yamls_cmds < <(find_files_by_extension $BASIC_CONFIGS_DIR/packages/ yaml)
process_yaml_commands $yamls_cmds

echo "found n yaml command files: ${#yamls_cmds[@]}"

#info "Installing required packages..."

#eval "$(fnm env --use-on-cd)"
#fnm use 16
#success "Switched to Node v16"

# find * -name "*.yaml" | while read fn; do
#     cmd="${fn%.*}"
#     set -- $cmd
#     info "Installing $1 packages..."
#     while read package; do
#         if [[ $package == $COMMENT ]]; then continue; fi
#         substep_info "Installing $package..."
#         $cmd $package
#     done < "$fn"
#     success "Finished installing $1 packages."
# done
