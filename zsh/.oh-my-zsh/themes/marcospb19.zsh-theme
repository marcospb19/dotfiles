# Personal theme from https://github.com/dotfiles/marcospb19
# Git prompt inspired from manjaro-zsh-config repo...

if [[ $USER != "root" ]]; then
	local PROMPT=' %{$fg[cyan]%}%~%{$reset_color%} '
	local ret_status="%(?:  :%{$fg_bold[red]%}:()"
else
	local PROMPT=' %{$fg[red]%}%~%{$reset_color%} '
	local ret_status="%(?:  :%{$fg_bold[cyan]%}:()"
fi


# Modify the colors and symbols in these variables as desired.
#local GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"          # plus/minus     - clean repo
local GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
local GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[green]%}]"
local GIT_PROMPT_AHEAD="%{$fg[red]%}A"            # A"NUM"         - ahead by "NUM" commits
local GIT_PROMPT_BEHIND="%{$fg[cyan]%}B"          # B"NUM"         - behind by "NUM" commits
local GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎" # lightning bolt - merge conflict
local GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}."   # red circle     - untracked files
local GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}." # yellow circle  - tracked files modified
local GIT_PROMPT_STAGED="%{$fg_bold[green]%}."    # green circle   - staged changes

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
		echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
	fi
}

git_prompt_string() {
	local git_where="$(parse_git_branch)"

	# If inside a Git repository, print its branch and state
	[ -n "$git_where" ] && [ "$git" ] && \
		echo "$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX" || \
		echo " %(?..%{$fg[red]%}[%{$fg[magenta]%}%?%{$fg[red]%}])"
}


git="true"
local RPROMPT='$(git_prompt_string) ${ret_status}%{$reset_color%} '







# RPROMPT='$(git_prompt_info) ${ret_status}%{$reset_color%} '

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git (%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}~"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
