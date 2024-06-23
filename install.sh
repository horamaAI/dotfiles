#!/usr/bin/env bash

echo "init dotfiles"

DIR=$(dirname "$0")
cd "$DIR"

export DOTFILES_DIR=$(realpath $DIR)

echo "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    # before uncommenting, load first function "success"
    # success "Sudo credentials updated."
    echo "Sudo credentials updated."

else
    # load first func "error"
    # error "Failed to obtain sudo credentials."
    echo "Failed to obtain sudo credentials."
fi

export PROFILE_NAME=dmahoro

# always setup default profile first
./profiles/basic/basic.sh

# if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP
