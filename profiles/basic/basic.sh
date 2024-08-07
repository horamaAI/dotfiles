#!/usr/bin/env bash

echo "init basic profile"

# step 0. first install essential tools needed for later use
essentials=(
    build-essential
    yq # for yaml files handling
)



# step 1. set up directories structure
# fetch basic environment variables, after that some basic environment variables should be loaded and can be used
source $DOTFILES_DIR/configs-shared/basic/basic.env
# load utils
source $PROFILE_CONFIGS_DIR/bin/functions/misc.sh
# create main folders structure
buff="$IFS"
IFS=:
(
    for dir in ${PROFILE_BASIC_DIRS[@]}; do
	mkdir -vp $dir
    done
    )
IFS="$backup_ifs"

# step 2. install basic tools and setup basic env, tools, aliases, etc.
apt_pkgs=$PROFILE_CONFIGS_DIR/apt.list
opt_pkgs=$PROFILE_CONFIGS_DIR/opt.list
pkgs=$apt_pkgs:$opt_pkgs

buff="$IFS"
IFS=:
(
    for pkg in ${pkgs[@]}; do
	echo "smthing"
    done
    )
IFS="$backup_ifs"

