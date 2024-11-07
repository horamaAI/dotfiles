
# folders and files
alias tree='tree -C -I '"'"'*~'"'"'' # need 'tree' command
alias treefolders='ls -aR -I.git | grep ":$" | perl -pe '"'"'s/:$//;s/[^-][^\/]*\//    /g;s/^    (\S)/└── \1/;s/(^    |    (?= ))/│   /g;s/    (\S)/└── \1/'"'"
alias treeall='find . -print | sed -e '"'"'s;[^/]*/;|____;g;s;____|; |;g'"'"''
alias treenohidden='find . ! -name "'"*~"'" -print | sed -e '"'"'s;[^/]*/;|____;g;s;____|; |;g'"'"''
alias ..='cd ../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias memacs='cd $MEMACS_DIR'
alias dotfiles='cd $DOTFILES_DIR'
alias merepos='~/Documents/repos'

# git
alias gsynch="bash ~/bin/git-sync.sh"

# utils
alias emacs='emacsclient -t'
alias psmy='ps uxf'
alias ls-no-hidden='ls -la -I'
alias doclean='sudo apt autoremove && sudo apt autoclean && sudo apt remove && sudo apt clean'
alias doupdates='sudo apt update && sudo apt upgrade && doclean'
