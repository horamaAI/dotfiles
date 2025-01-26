#!/usr/bin/env bash

COMMENT=\#*

# complete with further environment variables, for example some specific installation
echo "
# use for example sequence 'jk' as <ESC> for zsh-vi-mode
# can get annoying otherwise when need to use some shell keybindings
#export ZVM_VI_ESCAPE_BINDKEY=jk
export DOTFILES=$FINAL_DOTFILES_DIR
" >> $DOTFILES_TRGT_DIR/.zshrc_user
