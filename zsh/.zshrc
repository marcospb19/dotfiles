#!/usr/bin/env zsh
#
#               __
#      ___ ___ / /  ________
#   _ /_ /(_-</ _ \/ __/ __/
#  (_)/__/___/_//_/_/  \__/
#


# Path to oh-my-zsh.
export ZSH="$HOME/.oh-my-zsh"

plugins=()

# My custom theme, ~/.oh-my-zsh/themes/marcospb19
ZSH_THEME="marcospb19"

# Source configuration from oh-my-zsh defaults (not sure)
source $ZSH/oh-my-zsh.sh

# # Packages
#
# zsh-syntax-highlighting
# zsh-autosuggestions

# Enabling syntax highlighting
# Arch:
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Fedora:
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# # Enabling autosuggestion if not in TTY
# if [ "$DISPLAY" ]; then
#     # Arch:
#     source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#     # Fedora:
#     #source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# fi

# # Packages end

# Modularization
[ -f ./.profile ]   && . ./.profile
[ -f ./.aliases ]   && . ./.aliases
[ -f ./.functions ] && . ./.functions

HYPHEN_INSENSITIVE="true"
CASE_SENSITIVE="false"

# Allow shared history between root and user
ZSH_DISABLE_COMPFIX="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 200

# Enable command correction suggestion.
# ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Change history time format
# Formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Show me a crab
cat << EOF

       _~^~^~_        __ _  ___  __ _ ___
   \) /  o o  \ (/   /  ' \/ _ \/ _\` / _ \\
     '_   ¬   _'    /_/_/_/\___/\__,_\___/
     / '-----' \\

     Vicarious:
         What is experienced in the imagination throught the feelings or actions of another person.

EOF

PATH_CANDIDATES=(".cargo/bin" ".local/bin" ".bin")

for CANDIDATE in $PATH_CANDIDATES; do
    if [ -d "$HOME/.bin" ]; then
        export PATH=$HOME/$CANDIDATE:$PATH
    fi
done

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
