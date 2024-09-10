#!/usr/bin/env bash

COMMENT=\#*

info "Installing required packages..."

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
