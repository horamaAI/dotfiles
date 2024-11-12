#!/usr/bin/env bash

COMMENT=\#*

declare -an yamlscmds
mapfile -d '' yamlscmds < <(find_files_by_extension $BASIC_CONFIGS_DIR/packages/ yaml)
echo "fetched ${#yamlscmds[@]} yaml files to read commands from"
#declare -p yamlscmds
#echo "content: ${yamls_cmds[@]}"
process_commands_in_yamls yamlscmds

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
