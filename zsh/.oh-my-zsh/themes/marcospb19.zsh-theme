#!/usr/bin/zsh
# Personal theme from https://github.com/marcospb19/dotfiles

# User can type `git=false` in shell to disable the git prompt
git="true"

# Colors switch if you're root
if [[ $USER != "root" ]]; then
    local PROMPT=' %{$fg[magenta]%}%~%{$reset_color%} '
    local ret_status_color="%{$fg[red]%}"
else
    local PROMPT=' %{$fg[red]%}%~%{$reset_color%} '
    local ret_status_color="%{$fg[magenta]%}"
fi

# Modify the colors and symbols in these variables as desired.
local GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[white]%}["
local GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[white]%}]"
local GIT_PROMPT_PREFIX2="%{$reset_color%}%{$fg[white]%}("
local GIT_PROMPT_SUFFIX2="%{$reset_color%}%{$fg[white]%})"
local GIT_PROMPT_AHEAD="%{$reset_color%}%{$fg[red]%}A"          # A"NUM"     - ahead by "NUM" commits
local GIT_PROMPT_BEHIND="%{$reset_color%}%{$fg[cyan]%}B"        # B"NUM"     - behind by "NUM" commits
local GIT_PROMPT_MERGING="%{$reset_color%}%{$fg[magenta]%}⚡︎" # lightning  - merge conflict
local GIT_PROMPT_UNTRACKED="%{$reset_color%}%{$fg[red]%}?"    # red `u`    - untracked files
local GIT_PROMPT_MODIFIED="%{$reset_color%}%{$fg[yellow]%}±"  # yellow `m` - tracked files modified
local GIT_PROMPT_STAGED="%{$reset_color%}%{$fg[green]%}↑"     # green `s`  - staged changes

parse_git_branch_and_offsets() {
    # Start with Git branch/tag, or name-rev if on detached head
    local final_result="$(
        git symbolic-ref -q HEAD \
            || git name-rev --name-only --no-undefined --always HEAD
    )"

    # return early if there is no origin
    if ! git remote get-url origin &> /dev/null; then
        echo "$final_result - no origin"
        return
    fi

    # ahead/behind, current branch compared to origin copy
    local ahead_of_itself=""

    local num_ahead="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$num_ahead" -gt 0 ]; then
        ahead_of_itself=$ahead_of_itself${GIT_PROMPT_AHEAD}${num_ahead}
    fi
    local num_behind="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$num_behind" -gt 0 ]; then
        ahead_of_itself=$ahead_of_itself${GIT_PROMPT_BEHIND}${num_behind}
    fi

    local main_branch_name="$(git show-ref --verify --quiet refs/heads/main && echo "main" || echo "master")"

    # return early if we are in the main branch
    if [ "$final_result" = "refs/heads/$main_branch_name" ]; then
        if [ $ahead_of_itself ]; then
            final_result="$final_result%{$fg_bold[grey]%}|%{$reset%}$ahead_of_itself"
        fi
        echo "$final_result"
        return
    fi

    # ahead/behind, current branch compared to origin's main
    local ahead_of_main=""

    local origin_main_distance="$(git rev-list --left-right --count HEAD...origin/$main_branch_name | tr '\t' '\n')"
    local num_ahead=$(sed -n 1p <<< "$origin_main_distance")
    if [ "$num_ahead" -gt 0 ]; then
        ahead_of_main=$ahead_of_main${GIT_PROMPT_AHEAD}${num_ahead}
    fi
    local num_behind=$(sed -n 2p <<< "$origin_main_distance")
    if [ "$num_behind" -gt 0 ]; then
        ahead_of_main=$ahead_of_main${GIT_PROMPT_BEHIND}${num_behind}
    fi

    if [ $ahead_of_itself ]; then
        final_result="$final_result%{$fg_bold[grey]%}|%{$reset%}I$ahead_of_itself"
    fi
    if [ $ahead_of_main ]; then
        final_result="$final_result%{$fg_bold[grey]%}|%{$reset%}M$ahead_of_main"
    fi

    echo "$final_result"
}

parse_git_state() {
    # Show different symbols as appropriate for various Git repository states
    # Compose this value via multiple conditional appends.
    local GIT_STATE=""
    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
    fi
    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    fi
    if ! git diff --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    fi
    if ! git diff --cached --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    fi

    if [[ -n $GIT_STATE ]]; then
        echo "${GIT_PROMPT_PREFIX2}$GIT_STATE${GIT_PROMPT_SUFFIX2}"
    fi
}

git_prompt_string() {
    # If inside a Git repository, and user didn't disabled git rprompt
    if [ "$git" ] && git rev-parse --is-inside-work-tree &> /dev/null; then
        local git_where="$(parse_git_branch_and_offsets)"
        # print branch and state
        echo "$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg_bold[magenta]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
    else
        echo "%{$fg[white]%}- %{$fg[magenta]%}no repo%{$fg[white]%} -"
    fi
}

last_error_code() {
    code="$?"
    if [ ! "$code" = "0" ]; then
        echo "%{$fg[yellow]%}[${ret_status_color}${code}%{$fg[yellow]%}] "
    fi
}

timestamp() {
    echo " $GIT_PROMPT_PREFIX%{$fg_bold[magenta]%}%D{%H:%M:%S}$GIT_PROMPT_SUFFIX"
}

get_rprompt() {
    local error_code=`last_error_code`
    echo "${error_code}$(git_prompt_string)%{$reset_color%}$(timestamp)"
}

local RPROMPT='$(get_rprompt)'

# RPROMPT='$(git_prompt_info) ${ret_status}%{$reset_color%} '

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git (%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}~"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
