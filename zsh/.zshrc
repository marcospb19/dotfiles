#!/usr/bin/env zsh
#
#               __
#      ___ ___ / /  ________
#   _ /_ /(_-</ _ \/ __/ __/
#  (_)/__/___/_//_/_/  \__/
#


# Path to oh-my-zsh.
export ZSH="$HOME/.oh-my-zsh"

# My custom theme, ~/.oh-my-zsh/themes/marcospb19
ZSH_THEME="marcospb19"

# Allow shared history between root and user
ZSH_DISABLE_COMPFIX="true"

# Source configuration from oh-my-zsh defaults (not sure)
source $ZSH/oh-my-zsh.sh

# Modularization
[ -f ./.profile ]   && . ./.profile
[ -f ./.aliases ]   && . ./.aliases
[ -f ./.functions ] && . ./.functions

[ -d./.bin ] && export PATH=$PATH:$HOME/.bin

CASE_SENSITIVE="false"

# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Disable update checks.
# DISABLE_AUTO_UPDATE="true"

# Change how often to auto-update.
export UPDATE_ZSH_DAYS=30

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

# plugin location: ~/.oh-my-zsh/plugins/git
plugins=(
	git
#	plug2
#	plug3
)


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


# Enabling syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH=/home/marcospb19/.local/bin:$PATH


# Enable and disable my git prompt information
# git=

head -1 ~/.config/termite/colors

# export PATH=$PATH:$HOME/.bin
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.bin:$PATH
# Rust cache
export RUSTC_WRAPPER=sccache
# eval "$(starship init zsh)"

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
