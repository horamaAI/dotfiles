#!/usr/bin/env bash

COMMENT=\#*

DIR=$(dirname "$0")
cd "$DIR"

build_rc() {
  find . -iname "*rc*" -printf "%f\0"
  mapfile -d $'' rc_files < <(find . -iname "*rc*" -printf "%f\0")
  for rc in "${rc_files[@]}"; do
    echo "copying rc file $rc to $DOTFILES_TRGT_DIR/.$rc"
    cp $rc "$DOTFILES_TRGT_DIR/.$rc"
  done
}

# copy rc files to target profile folder (as hidden files of course)
build_rc

# final zsh configurations:
# add zsh as authorized valid login shell (command -v returns full
# path of zsh and tee appends it to /etc/shells, which contains
# allowed shells)
command -v zsh | sudo tee -a /etc/shells

# use zsh as default shell
sudo chsh -s $(which zsh) $USER

## installs nvm (Node Version Manager), for  node.js
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
#
## download and install Node.js (might need a terminal restart)
#nvm install 22
#node -v # verifies Node.js version is in the environment
#npm -v # verifies npm version is in the environment
