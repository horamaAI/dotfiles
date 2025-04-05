#!/usr/bin/env bash

COMMENT=\#*

declare -an yamls_cmds_files
mapfile -d '' yamls_cmds_files < <(find_files_by_extension $BASIC_CONFIGS_DIR/packages/ yaml)
echo "fetched ${#yamls_cmds_files[@]} yaml files to read commands from"
#declare -p yamls_cmds_files
#echo "content: ${yamls_cmds[@]}"
#INSTALLED_APPS+="($(process_commands_in_yamls yamls_cmds_files | tail -n1))"
process_commands_in_yamls yamls_cmds_files INSTALLED_APPS INSTALLED_APPS_TEST_CMDS
for akey in "${!INSTALLED_APPS[@]}"
do
  echo "[content INSTALLED_APPS PROCESS_COMMANDS_IN_YAMLS](key: value): (${akey}: ${INSTALLED_APPS[${akey}]})"
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
