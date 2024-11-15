#!/usr/bin/env bash

COMMENT=\#*

# complete with environment variables from the specific installation
echo "
export DOTFILES=$FINAL_DOTFILES_DIR
" >> $FINAL_DOTFILES_DIR/.zshrc_user
