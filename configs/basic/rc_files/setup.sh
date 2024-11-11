#!/usr/bin/env bash

COMMENT=\#*

build_rc() {
  find . -iname "*rc*" -printf "%f\0"
  mapfile -d $'' rc_files < <(find . -iname "*rc*" -printf "%f\0")
  for rc in "${rc_files[@]}"; do
    echo "test: $rc vs $TARGET_PROFILE_FOLDER/.$rc"
    cp $rc "$TARGET_PROFILE_FOLDER/.$rc"
  done
}

# copy rc files to target profile folder (as hidden files of course)
build_rc
# configure zsh

