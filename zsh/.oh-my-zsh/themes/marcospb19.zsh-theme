#!/usr/bin/zsh
# Personal theme from https://github.com/marcospb19/dotfiles

# User can type `git=false` in shell to disable the git prompt
git="true"

# Colors switch if you're root
if [[ $USER != "root" ]]; then
	local PROMPT=' %{$fg[cyan]%}%~%{$reset_color%} '
	local ret_status_color="%{$fg[red]%}"
else
	local PROMPT=' %{$fg[red]%}%~%{$reset_color%} '
	local ret_status_color="%{$fg[cyan]%}"
fi

# Modify the colors and symbols in these variables as desired.
#local GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"          # plus/minus     - clean repo
local GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[cyan]%}["
local GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[cyan]%}]"
local GIT_PROMPT_PREFIX2="%{$reset_color%}%{$fg[white]%}("
local GIT_PROMPT_SUFFIX2="%{$reset_color%}%{$fg[white]%})"
local GIT_PROMPT_AHEAD="%{$reset_color%}%{$fg[red]%}A"             # A"NUM"     - ahead by "NUM" commits
local GIT_PROMPT_BEHIND="%{$reset_color%}%{$fg[cyan]%}B"           # B"NUM"     - behind by "NUM" commits
local GIT_PROMPT_MERGING="%{$reset_color%}%{$fg[magenta]%}⚡︎" # lightning  - merge conflict
local GIT_PROMPT_UNTRACKED="%{$reset_color%}%{$fg[red]%}¿?"    # red `u`    - untracked files
local GIT_PROMPT_MODIFIED="%{$reset_color%}%{$fg[yellow]%}~±"  # yellow `m` - tracked files modified
local GIT_PROMPT_STAGED="%{$reset_color%}%{$fg[green]%}*↑"     # green `s`  - staged changes

parse_git_branch() {
	# Show Git branch/tag, or name-rev if on detached head
	( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_state() {
	# Show different symbols as appropriate for various Git repository states
	# Compose this value via multiple conditional appends.
	local GIT_STATE=""
	local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_AHEAD" -gt 0 ]; then
		# GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
		GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD}${NUM_AHEAD}
	fi
	local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_BEHIND" -gt 0 ]; then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND}${NUM_BEHIND}
	fi
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
	local git_where="$(parse_git_branch)"

	# If inside a Git repository, and user didn't disabled git rprompt
	if [ -n "$git_where" ] && [ "$git" ]; then
		# print its branch and state
		echo "$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg_bold[magenta]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
	else
		echo "%{$fg[cyan]%}- %{$fg[magenta]%}no repo%{$fg[cyan]%} - "
	fi
}

last_error_code() {
	code="$?"
	if [ ! "$code" = "0" ]; then
		echo "%{$fg[yellow]%}[${ret_status_color}${code}%{$fg[yellow]%}] "
	fi
}

timestamp() {
	echo " $GIT_PROMPT_PREFIX%{$fg_bold[yellow]%}%D{%H:%M:%S}$GIT_PROMPT_SUFFIX"
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
