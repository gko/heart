if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
	tput sgr0
	if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
		BLUE=$(tput setaf 75)
		RED=$(tput setaf 9)
		ORANGE=$(tput setaf 172)
		GREEN=$(tput setaf 70)
		PURPLE=$(tput setaf 141)
		WHITE=$(tput setaf 255)
		YELLOW=$(tput setaf 3)
	else
		RED=$(tput setaf 1)
		ORANGE=$(tput setaf 1)
		GREEN=$(tput setaf 2)
		BLUE=$(tput setaf 4)
		PURPLE=$(tput setaf 5)
		WHITE=$(tput setaf 7)
		YELLOW=$(tput setaf 3)
	fi
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
else
	RED="\033[1;31m"
	ORANGE="\033[1;33m"
	GREEN="\033[1;32m"
	BLUE="\033[1;34m"
	PURPLE="\033[1;35m"
	WHITE="\033[1;37m"
	YELLOW="\033[1;33m"
	BOLD=""
	RESET="\033[m"
fi

# only if we're on remote machine
if [[ ! $HOSTNAME =~ 'localhost' ]]; then
  _hostname="$RESET at \h"
fi

set_prompt() { 
  local result=$?

  PS1="\[$RESET\]\n \[$BOLD\]\[$RED\]\u\[$_hostname\]\[$RESET\] in \[$BOLD\]\[$GREEN\]\W\[$RESET\]\$git_branch\[$BOLD\]\[$RED\]\$git_dirty\[$RESET\]\n "

  if [[ $result -eq 0 ]]; then
    PS1+="\[$BOLD\]\[$RED\]❤ \[$RESET\]"
  else
    PS1+="\[$BOLD\]\[$RED\]♡ \[$RESET\]"
  fi
}

export PROMPT_COMMAND="set_prompt; $PROMPT_COMMAND >/dev/null"
