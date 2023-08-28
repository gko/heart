# https://unix.stackexchange.com/a/302710
unsetopt prompt_cr prompt_sp

if [[ -z "$THEME_ROOT" ]]; then
	if [[ "${(%):-%N}" == '(eval)' ]]; then
		if [[ "$0" == '-antigen-load' ]] && [[ -r "${PWD}/heart_theme.zsh" ]]; then
			# Antigen uses eval to load things so it can change the plugin (!!)
			# https://github.com/zsh-users/antigen/issues/581
			export THEME_ROOT=$PWD
		else
			print -P "%F{red}You must set THEME_ROOT to work from within an (eval).%f"
			return 1
		fi
	else
		# Get the path to file this code is executing in; then
		# get the absolute path and strip the filename.
		# See https://stackoverflow.com/a/28336473/108857
		export THEME_ROOT=${${(%):-%x}:A:h}
	fi
fi

__get_git_status() {
	local INDEX git_status=""
	local red_color="%{[38;5;196m%}"
	local yellow_color="%{[38;5;214m%}"
	local blue_color="%{[38;5;147m%}"

	local GIT_STATUS_UNTRACKED="%B$blue_color?"
	local GIT_STATUS_ADDED="%B$yellow_color+"
	local GIT_STATUS_MODIFIED="%B$red_color*"

	INDEX=$(command git status --porcelain -b 2> /dev/null)

	# Check for untracked files
	if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
		git_status="$GIT_STATUS_UNTRACKED$git_status"
	fi

	# Check for modified files
	if $(echo "$INDEX" | command grep '^[ MARC]M ' &> /dev/null); then
		git_status="$GIT_STATUS_MODIFIED$git_status"
	fi

	# Check for staged files
	if $(echo "$INDEX" | command grep '^A[ MDAU] ' &> /dev/null); then
		git_status="$GIT_STATUS_ADDED$git_status"
	elif $(echo "$INDEX" | command grep '^M[ MD] ' &> /dev/null); then
		git_status="$GIT_STATUS_ADDED$git_status"
	elif $(echo "$INDEX" | command grep '^UA' &> /dev/null); then
		git_status="$GIT_STATUS_ADDED$git_status"
	fi

	echo $git_status
}

# https://github.com/ohmyzsh/ohmyzsh/blob/03a0d5bbaedc732436b5c67b166cde954817cc2f/lib/git.zsh#L93C1-L106C2
function __git_current_branch() {
	local ref
	ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
	local ret=$?

	if [[ $ret != 0 ]]; then
		[[ $ret == 128 ]] && return  # no git repo.
		ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
	fi

	echo ${ref#refs/heads/}
}

git_info() {
	local git_branch="$(__git_current_branch)" git_status="$(__get_git_status)"

	[[ -z $git_branch ]] && return

	STATUS="%F{default}%b($git_branch)$git_status%b%F{default}"

	echo "$STATUS"
}

precmd() {
	local result=$?
	local maroon_color="%{[38;5;001m%}"
	local green_color="%{[38;5;070m%}"
	local _hostname="%b%F{default} at %m"

	PS1=" %B$maroon_color%n$_hostname %b%F{default}in %B$green_color%(4~|…/%2~|%~)%f$(git_info)
 %F{default}"

	if [[ $result -eq 0 ]]; then
		PS1+="%B$maroon_color❤ %b%F{default}"
	else
		PS1+="%B$maroon_color♡ %b%F{default}"
	fi
}

__add_new_line_before_prompt() {
	print
}

add-zsh-hook precmd __add_new_line_before_prompt
