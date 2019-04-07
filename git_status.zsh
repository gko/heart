#
# Git status
#

GIT_STATUS_UNTRACKED="%B%F{cyan}?"
GIT_STATUS_ADDED="%B%F{yellow}+"
GIT_STATUS_MODIFIED="%B%F{red}*"

get_git_status() {
	local INDEX git_status=""

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
