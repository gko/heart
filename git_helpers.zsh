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
