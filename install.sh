#!/usr/bin/env bash

echo "init dotfiles"

DIR=$(dirname "$0")
cd "$DIR"

export DOTFILES_ENV_DIR=$(realpath $DIR)

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

sudo apt update && sudo apt upgrade

export TRGT_DOTFILES_DIR_NAME=dotfiles_$USER
export DOTFILES_TRGT_DIR=$DOTFILES_ENV_DIR/$TRGT_DOTFILES_DIR_NAME
# where the final built folder should go
export FINAL_DOTFILES_DIR=$HOME/$TRGT_DOTFILES_DIR_NAME

# always setup default profile first
./profiles/basic/basic.sh

# if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP

# if selected basic, then do nothing, basic profile is already configured,
# export PROFILE_NAME=dmahoro

# final step. stow generated folder: create symlinks from home folder to stow target
# constraint: dir to stow has to be a direct child of home: ~/dir_to_stow
#cd "$DOTFILES_TRGT_DIR"
mv $DOTFILES_TRGT_DIR $FINAL_DOTFILES_DIR
cd "$FINAL_DOTFILES_DIR"

# uncomment following to allow generating symlinks to home
stow .
