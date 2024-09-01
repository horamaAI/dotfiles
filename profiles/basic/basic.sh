#!/usr/bin/env bash

echo "init basic profile"
DIR=$(dirname "$0")
cd "$DIR"

# step 0. set up directories structure
# fetch basic environment variables, after that basic environment variables should be loaded and ready to be used
source ./basic.env
# load utils
source $BASIC_CONFIGS_DIR/bin/functions/misc.sh

# create basic folders structure
buff_ifs="$IFS"
IFS=:
(
    for dir in ${PROFILES_DIRS_BASIC[@]}; do
      mkdir -vp $dir
    done
    )
IFS="$buff_ifs"

# step 1. always install first build-essential, and following tools
apt_essentials=(
    build-essential # g++, make, etc.
    yq # to parse yaml files containing required installations, will install python3
    npm # for pajv
    # add here any other essential tool to load first (not comma separated)
)

npm_essentials=(
    pajv # yaml files schema validator (to validate yaml instance against schema)
    # add here any other essential tool to load first (not comma separated)
)

buff_ifs="$IFS"
IFS=:
(
    docommand="sudo apt install"
    for pkg in ${apt_essentials[@]}; do
      echo "attempting to install: '$pkg' with 'apt install'"
      eval "$docommand $pkg"
    done
    )
IFS="$buff_ifs"

buff_ifs="$IFS"
IFS=:
(
    docommand="sudo npm install -g"
    for pkg in ${npm_essentials[@]}; do
      echo "attempting to install: '$pkg' with npm"
      eval "$docommand $pkg"
    done
    )
IFS="$buff_ifs"

# step 2. install basic tools and setup basic env, tools, aliases, etc.
apt_pkgs=$PROFILE_CONFIGS_DIR/apt.list
opt_pkgs=$PROFILE_CONFIGS_DIR/opt.list
pkgs=$apt_pkgs:$opt_pkgs

buff_ifs="$IFS"
IFS=:
(
    for pkg in ${pkgs[@]}; do
      echo "smthing"
    done
    )
IFS="$buff_ifs"

