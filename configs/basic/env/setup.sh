#!/usr/bin/env bash

COMMENT=\#*

# complete with environment variables from the specific installation
echo "
export DOTFILES=$FINAL_DOTFILES_DIR
" >> $DOTFILES_TRGT_DIR/.zshrc_user
