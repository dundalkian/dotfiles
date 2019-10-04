
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\u@\h:\w \`parse_git_branch\` \\$ "


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# for tab completion, ignore case
bind "set completion-ignore-case on"
# for tab completion, makes hypens and underscores the same. Saves a shift key
bind "set completion-map-case on"
# for tab completion, shows all possible matches
bind "set show-all-if-ambiguous on"
# bash autocorrects small misspellings in tab completion directories
shopt -s dirspell
# bash autocorrects small misspellings in cd command directories
shopt -s cdspell



# Larry Additions
set -o vi
alias ls='ls --color=always'
alias la='ls -a --color=always'
alias ll='ls -l --color=always'
alias llt='ls -lt --color=always'
alias less='less --RAW-CONTROL-CHARS'
alias grep='grep --color=auto'
alias gtcs='cd ~/Fall2019/CMSC433/'

alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias ......='cd ../../../../../..'
alias .......='cd ../../../../../../..'
alias ........='cd ../../../../../../../..'
alias .........='cd ../../../../../../../../..'
alias ..........='cd ../../../../../../../../../..'
alias ...........='cd ../../../../../../../../../../..'
alias ............='cd ../../../../../../../../../../../..'
alias zathura='zathura --fork'
alias weather='curl wttr.in'

function netstop {
    sudo rfkill block wlan
    sudo pkill -9 dhcpcd
    sudo pkill -9 wpa_supplicant
}

function netstart {
    sudo rfkill unblock wlan
    sudo netctl switch-to "$1"
}

# Import colorscheme from 'wal' asynchronously
(cat ~/.cache/wal/sequences &)
