#!/usr/bin/env sh

echo "init dotfiles"

DIR=$(dirname "$0")
cd "$DIR"

echo "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi



# if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP
