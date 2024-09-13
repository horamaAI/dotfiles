#!/usr/bin/env bash

COMMENT=\#*

declare -a yamls_cmds
mapfile -d '' yamls_cmds < <(find_files_by_extension $BASIC_CONFIGS_DIR/packages/ yaml)

echo "found n yaml command files: ${#yamls_cmds[@]}"

for cmd_file in ${yamls_cmds[@]}; do
  run_yaml_command_entry $cmd_file
done

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
