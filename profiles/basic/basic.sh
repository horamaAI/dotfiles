#!/usr/bin/env sh

echo "init basic profile"

# step 1. set up directories structure
# fetch basic environment variables, after that some basic environment variables should be loaded and can be used
source ../../configs/basic/basic.env
# load utils
source $PROFILE_CONFIGS_DIR/bin/functions
