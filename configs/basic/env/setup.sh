#!/usr/bin/env bash

COMMENT=\#*

# complete with environment variables from the specific installation
echo "
# use sequence 'jk' as <ESC> for zsh-vi-mode
# otherwise it's annoying and can't use some shell keybindings
export ZVM_VI_ESCAPE_BINDKEY=jk
export DOTFILES=$FINAL_DOTFILES_DIR
" >> $DOTFILES_TRGT_DIR/.zshrc_user
