#!/usr/bin/env bash

echo "initializing basic profile"
DIR=$(dirname "$0")
# echo "dir value:$DIR"
cd "$DIR"

# pwd

# define global variables:
# 'INSTALLED_APPS': needed to store installed tools, apps, packages, etc.
# it will be utilized later to validate that those installed packages were
# properly installed (or not).
# 'INSTALLED_APPS' is a global associative array of type:
# ~"cmd" -> [list_of_packages_to_install_using_the_cmd]~
# ~cmd~ is the command that was used to install the package.
# 2 solutions design for the associative array:
# 1. [preferred] 1D associative array of space separated packages names, i.e. ["cmd"  -> "pkg1 pkg2 ..."],
# 2. 2D associative array of array of packages (["cmd" -> [pkg1, pkg2, ...]])
#
# 'INSTALLED_APPS_TEST_CMDS' is an associative array that stores the commands
# to use in order to test if the installation went properly
# 'INSTALLED_APPS' and 'INSTALLED_APPS_TEST_CMDS' share the same key(s)
# eg: ['apt' -> 'pkg1 pkg2 etc.'], ['apt' -> 'cmnd_to_test_installed_pkgs']
# advantage is: with same key, have access to different type of data
declare -A INSTALLED_APPS
declare -A INSTALLED_APPS_TEST_CMDS
export INSTALLED_APPS
export INSTALLED_APPS_TEST_CMDS

# 0. set up directories structure, and other basic utils:
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

# 1. always install first build-essential, and other pre-required tools
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

#declare -A toto="($(execute_install_command "apt" "sudo apt install ${apt_essentials[*]}" | tail -n1))"
#echo "going to test in toto:${!toto[@]}"
#for akey in "${!toto[@]}"
#do
#  echo "in toto:[content](key: value): (${akey}: ${toto[${akey}]})"
#done

#INSTALLED_APPS+=("$(execute_install_command "apt" "sudo apt install ${apt_essentials[*]}" | tail -n1)")

# install prerequisites
# !!: careful: installing a command (through 'execute_install_command')
# usually has to be preceded by registering the command used for
# testing (add line to: 'INSTALLED_APPS_TEST_CMDS')
# here, no need to add command for testing 'apt' commands, it's already
# defined in yaml file 'apt.yaml'
execute_install_command "apt" "sudo apt install ${apt_essentials[*]}" INSTALLED_APPS
echo "next command (npm) is suspended (for now), does nothing, since npm doesn't check context at all, it just reinstall everything"
INSTALLED_APPS_TEST_CMDS[npm]='npm list -g --depth=0 | grep -q '
#execute_install_command "npm" "sudo npm install -g ${npm_essentials[*]}" INSTALLED_APPS

# buff_ifs="$IFS"
# IFS=:
# (
#     docommand="sudo apt install"
#     for pkg in ${apt_essentials[@]}; do
#       execute_install_command "apt install" $docommand $pkg
#     done
#     )
# IFS="$buff_ifs"

# 2. install other required tools and setup: (sourced -> variables propagated)
# basic env, tools, aliases, etc.
. $BASIC_CONFIGS_DIR/packages/setup.sh

# 3. configure rc files
bash $BASIC_CONFIGS_DIR/rc_files/setup.sh

# 4. complete some rc files configs
bash $BASIC_CONFIGS_DIR/env/setup.sh

# 5. for vim
cp $BASIC_CONFIGS_DIR/vim/vimrc "$DOTFILES_TRGT_DIR/.vimrc"

# 6. test that everything went well
#bash $BASIC_CONFIGS_DIR/tests/test.bats

# test: show content 
#for key value in "${(@kv)INSTALLED_APPS}" # where ~(@kv)~ is a parameter expansion zsh style, so might not work with other shells, bash for example
for akey in "${!INSTALLED_APPS[@]}"
do
  echo "[content INSTALLED_APPS](key: value): (${akey}: ${INSTALLED_APPS[${akey}]})"
done

for akey in "${!INSTALLED_APPS_TEST_CMDS[@]}"
do
  echo "[content INSTALLED_APPS_TEST_CMDS](key: value): (${akey}: ${INSTALLED_APPS_TEST_CMDS[${akey}]})"
done
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

