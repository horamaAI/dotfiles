#!/usr/bin/env bash

echo "initializing basic profile"
DIR=$(dirname "$0")
# echo "dir value:$DIR"
cd "$DIR"

# pwd

# 0. set up directories structure, and other basic utils
# fetch basic environment variables, after that basic environment variables should be loaded and ready to be used
source $DOTFILES_ENV_DIR/configs/basic/env/basic.env
# load utils
#source $BASIC_CONFIGS_DIR/bin/functions/misc.sh
for funcs in $BASIC_CONFIGS_DIR/bin/functions/*; do
  source $funcs
done

# create basic folders structure
buff_ifs="$IFS"
IFS=:
(
    for dir in ${PROFILES_DIRS_BASIC[@]}; do
      make_dir $dir
    done
    )
IFS="$buff_ifs"

# 1. always install first build-essential, and following tools
apt_essentials=(
    build-essential # g++, make, etc.
    yq # to parse yaml files containing required installations, will install python3
    npm # for pajv
    stow # for linking generated target profile and home (automatic symlinks)
    # add here any other essential tool to load first (not comma separated)
)

npm_essentials=(
    pajv # yaml files schema validator (to validate yaml instance against schema)
    # add here any other essential tool to load first (not comma separated)
)

execute_command "apt" "sudo apt install ${apt_essentials[*]}"
echo "comment next command and do nothing for now, since npm reinstalls everything, it doesn't check context at all"
#execute_command "npm" "sudo npm install -g" "${npm_essentials[*]}"

# buff_ifs="$IFS"
# IFS=:
# (
#     docommand="sudo apt install"
#     for pkg in ${apt_essentials[@]}; do
#       execute_command "apt install" $docommand $pkg
#     done
#     )
# IFS="$buff_ifs"

# 2. install other required tools and setup:
# basic env, tools, aliases, etc.
. $BASIC_CONFIGS_DIR/packages/setup.sh

# 3. configure rc files
bash $BASIC_CONFIGS_DIR/rc_files/setup.sh

# 4. complete some rc files configs
bash $BASIC_CONFIGS_DIR/env/setup.sh

# 5. for vim
cp $BASIC_CONFIGS_DIR/vim/vimrc "$DOTFILES_TRGT_DIR/.vimrc"

# 6. test that everything went well
bash $BASIC_CONFIGS_DIR/tests/test.bats

exit $?

#apt_pkgs=$PROFILE_CONFIGS_DIR/apt.list
#opt_pkgs=$PROFILE_CONFIGS_DIR/opt.list
#pkgs=$apt_pkgs:$opt_pkgs
#
#buff_ifs="$IFS"
#IFS=:
#(
#    for pkg in ${pkgs[@]}; do
#      echo "smthing"
#    done
#    )
#IFS="$buff_ifs"

