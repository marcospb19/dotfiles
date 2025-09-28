#!/usr/bin/env zsh
#               __
#      ___ ___ / /  ________
#   _ /_ /(_-</ _ \/ __/ __/
#  (_)/__/___/_//_/_/  \__/
#

# Path to oh-my-zsh.
export ZSH="$HOME/.oh-my-zsh"

# Custom theme at `~/.oh-my-zsh/themes/marcospb19``
ZSH_THEME="marcospb19"

zstyle ':omz:update' mode disabled
source $ZSH/oh-my-zsh.sh
zstyle ':omz:update' mode disabled

plugins=()

# Enable `syntax-highlighting` and `autosuggestions`
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-fzf-plugin/fzf.plugin.zsh

# hide duplicates from history, useful for `fzf`
setopt HIST_FIND_NO_DUPS

# Imports
[ -f ~/.aliases ]   && . ~/.aliases
[ -f ~/.functions ] && . ~/.functions

# TODO is this even working
HYPHEN_INSENSITIVE="true"
CASE_SENSITIVE="false"
# Allow shared history between root and user
ZSH_DISABLE_COMPFIX="true"

# Enable command correction suggestion.
ENABLE_CORRECTION="false"

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

# cat << EOF
#
#                                         ,
#               ,-.       _,---._ __     / \\
#              /  )    .-'       \`./    /   \\
#             (  (   ,'            \`---/    /|
#              \\  \`-"             \\'   \\   / |
#               \`.              ,  \\    \\ /  |
#                /\`.          ,'-\`-------Y   |
#               (            ;           |   '
#               |  ,-.    ,-'            |  /
#               |  | (   |               | /
#               )  |  \\  \`.______________|/
#               \`--'   \`--'
#
#
# EOF
cat << EOF

        _~^~^~_
    \) /  o o  \ (/
      (_   ¬   _)
      / '-----' \\

EOF

PATH_CANDIDATES=(
    ".cargo/bin"
    ".local/bin"
    ".bin"
)

for CANDIDATE in $PATH_CANDIDATES; do
    if [ -d "$HOME/$CANDIDATE" ]; then
        export PATH=$HOME/$CANDIDATE:$PATH
    fi
done
