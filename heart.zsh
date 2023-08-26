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

source "$THEME_ROOT/git_status.zsh"

git_info() {
	local git_branch="$(git_current_branch)" git_status="$(get_git_status)"

	[[ -z $git_branch ]] && return

	STATUS="%F{default}%b($git_branch)$git_status%b%F{default}"

	echo "$STATUS"
}

# only if we're on remote machine
if [[ ! $HOSTNAME =~ 'localhost' ]]; then
	_hostname="%b%F{default} at %m"
fi

precmd() {
	# https://stackoverflow.com/a/50103965/676756
	if [ -z "$ADD_EMPTY_LINE_BEFORE_PROMPT" ]; then
		ADD_EMPTY_LINE_BEFORE_PROMPT=1
	else
		# we want to add new line if the previous command wasn't clear
		# and if it was an alias that it did't call clear
		last_command=$(fc -ln -1)
		if [[ "$last_command" != "clear" && ! $(alias "$last_command") =~ "=clear$" ]]; then
			echo
		fi
	fi

	local result=$?
	local red_color=$FG[001]
	local green_color=$FG[070]

	PS1=" %B$red_color%n$_hostname %b%F{default}in %B$green_color%(4~|…/%2~|%~)%f$(git_info)
 %F{default}"

	if [[ $result -eq 0 ]]; then
		PS1+="%B$red_color❤ %b%F{default}"
	else
		PS1+="%B$red_color♡ %b%F{default}"
	fi
}
