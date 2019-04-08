#
# Git status
#

get_git_status() {
	local INDEX git_status=""
	local red_color=$FG[196]
	local yellow_color=$FG[214]
	local blue_color=$FG[147]

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
