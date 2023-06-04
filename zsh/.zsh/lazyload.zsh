# Open explorer here
e() {
	explorer $(cygpath -d "$@")
	return 0
}

# recompile all zsh files
zcompile_all() {
	[ -e "$HOME/.zsh/private.zsh" ] && zcompile ~/.zsh/private.zsh
	[ -e "$HOME/.zsh/user-lazy.zsh" ] && zcompile ~/.zsh/user-lazy.zsh
	[ -e "$HOME/.zsh/user-before.zsh" ] && zcompile ~/.zsh/user-before.zsh
	[ -e "$HOME/.zsh/user-after.zsh" ] && zcompile ~/.zsh/user-after.zsh
	zcompile ~/.zsh/rc.zsh
	zcompile ~/.zsh/lazyload.zsh
	zcompile ~/.zsh/p10k.zsh
	zcompile ~/.zsh/nvm/nvm.sh
	zcompile ~/.zsh/fnvm/fnvm.sh
	zcompile ~/.zsh/defer/zsh-defer.plugin.zsh
	( rm ~/.zsh/omz/lib/*.zsh.zwc -f ) 2>/dev/null
	find ~/.zsh/powerlevel10k/*.zsh-theme | xargs -i zsh -c 'zcompile {}'
	find ~/.zsh/powerlevel10k/internal/*.zsh | xargs -i zsh -c 'zcompile {}'
	find ~/.zsh/powerlevel10k/gitstatus/*.zsh | xargs -i zsh -c 'zcompile {}'
	( find ~/.zsh/omz/lib/*.zsh | xargs -i zsh -c 'zcompile {}' ) 2>/dev/null
	( find ~/.zsh/zcompdump*.zsh | xargs -i zsh -c 'zcompile {}' ) 2>/dev/null
}
omztrim() {
	omzlib=$HOME/.zsh/omz/lib
	rm $omzlib/bzr.zsh $omzlib/correction.zsh $omzlib/diagnostics.zsh\
	   $omzlib/directories.zsh $omzlib/git.zsh $omzlib/grep.zsh $omzlib/misc.zsh\
	   $omzlib/nvm.zsh $omzlib/prompt_info_functions.zsh $omzlib/spectrum.zsh\
	   $omzlib/termsupport.zsh $omzlib/theme-and-appearance.zsh $omzlib/vcs_info.zsh 2>/dev/null
}
zupdate() {
	git pull $HOME/.zsh/defer --depth 1
	git pull $HOME/.zsh/nvm --depth 1
	git pull $HOME/.zsh/powerlevel10k --depth 1
	fnvm_update
	omz update
	omztrim
	zcompile_all
}

# Git commands
# From https://github.com/cmilr/Git-Beautify-For-MacOS-Terminal/blob/master/bash_profile
txtpur='\e[0;35m' # Purple
bldcyn='\e[1;36m' # Cyan
txtrst='\e[0m'    # Text Reset
# Basic log
alias log="printf '$bldcyn' > /tmp/gitlog ; git log --pretty=format:'%D' -1 >> /tmp/gitlog ; printf '\n' >> /tmp/gitlog ; git log --color --pretty=format:'%C(green)%h%Creset ≁ %C(yellow)%>(12,trunc)%cr%C(white) %>(11,trunc)%an%C(green) ⟹  %C(blue) %s' --abbrev-commit --date=relative >> /tmp/gitlog ; less /tmp/gitlog ; rm /tmp/gitlog" 
# Basic log with graph
alias logg="printf '$bldcyn' > /tmp/gitlog ; git log --pretty=format:'%D' -1 >> /tmp/gitlog ; printf '\n' >> /tmp/gitlog ; git log --color --graph --pretty=format:'%C(green)%h%Creset ≁ %C(yellow)%>(12,trunc)%cr%C(white) %>(11,trunc)%an%C(green) ⟹  %C(blue) %s' --abbrev-commit --date=relative >> /tmp/gitlog ; less /tmp/gitlog ; rm /tmp/gitlog"
# Verbose log
alias logv="printf '$bldcyn' > /tmp/gitlog ; git log --pretty=format:'%D' -1 >> /tmp/gitlog ; printf '\n' >> /tmp/gitlog ; git log --color --pretty=format:'%C(green)%h%Creset ≁ %C(yellow)%>(12,trunc)%cr%C(white) %>(11,trunc)%an %Creset%ce%C(green) ⟹  %C(blue) %s' --abbrev-commit --date=relative >> /tmp/gitlog ; less /tmp/gitlog ; rm /tmp/gitlog"
# Verbose log with graph
alias loggv="printf '$bldcyn' > /tmp/gitlog ; git log --pretty=format:'%D' -1 >> /tmp/gitlog ; printf '\n' >> /tmp/gitlog ; git log --color --graph --pretty=format:'%C(green)%h%Creset ≁ %C(yellow)%>(12,trunc)%cr%C(white) %>(11,trunc)%an %Creset%ce%C(green) ⟹  %C(blue) %s' --abbrev-commit --date=relative >> /tmp/gitlog ; less /tmp/gitlog ; rm /tmp/gitlog"
# Log with full commit messages
alias logm="printf '$bldcyn' > /tmp/gitlog ; git log --pretty=format:'%D' -1 >> /tmp/gitlog ; printf '\n' >> /tmp/gitlog ; git log --color --format=format:'%Creset%Cgreen%h%Creset | %C(white)%an | %C(yellow)%cr%n%Creset%s%n%n%b%n' >> /tmp/gitlog ; less /tmp/gitlog ; rm /tmp/gitlog"
# Show refs
alias refs="printf '$bldcyn' ; git show-ref --abbrev && printf '$txtrst'"
# Show remote refs and urls
alias remotes="printf '$txtpur' ; git remote -v && printf '$bldcyn\n' ; git branch -r --no-color && printf '$txtrst'"

# Sets color variable such as $fg, $bg, $color and $reset_color
# autoload -U colors && colors

# use diff color
alias diff --color "$@"

# use ls color
source <([ -e "$HOME/.dircolors" ] && dircolors -b "$HOME/.dircolors" || dircolors -b)
alias ls='ls --color=tty'

# Expand variables and commands in PROMPT variables
# setopt prompt_subst

# misc
{
	autoload -Uz is-at-least
	# *-magic is known buggy in some versions; disable if so
	if [[ $DISABLE_MAGIC_FUNCTIONS != true ]]; then
		for d in $fpath; do
			if [[ -e "$d/url-quote-magic" ]]; then
				if is-at-least 5.1; then
					autoload -Uz bracketed-paste-magic
					zle -N bracketed-paste bracketed-paste-magic
				fi
				autoload -Uz url-quote-magic
				zle -N self-insert url-quote-magic
			break
			fi
		done
	fi

	# setopt multios              # enable redirect to multiple streams: echo >file1 >file2
	# setopt long_list_jobs       # show long list format job notifications
	# setopt interactivecomments  # recognize comments

	env_default 'PAGER' 'less'
	env_default 'LESS' '-R'

	## super user alias
	alias _='sudo '

	## more intelligent acking for ubuntu users and no alias for users without ack
	if (( $+commands[ack-grep] )); then
		alias afind='ack-grep -il'
	elif (( $+commands[ack] )); then
		alias afind='ack -il'
	fi
}

# use grep color
{
	__GREP_CACHE_FILE="$ZSH_CACHE_DIR"/grep-alias
	__GREP_ALIAS_CACHES=("$__GREP_CACHE_FILE"(Nm-1)) # See if there's a cache file modified in the last day
	if [[ -n "$__GREP_ALIAS_CACHES" ]]; then
		source "$__GREP_CACHE_FILE"
	else
		grep-flags-available() {
			command grep "$@" "" &>/dev/null <<< ""
		}

		# Ignore these folders (if the necessary grep flags are available)
		EXC_FOLDERS="{.bzr,CVS,.git,.hg,.svn,.idea,.tox}"

		# Check for --exclude-dir, otherwise check for --exclude. If --exclude
		# isn't available, --color won't be either (they were released at the same
		# time (v2.5): https://git.savannah.gnu.org/cgit/grep.git/tree/NEWS?id=1236f007
		if grep-flags-available --color=auto --exclude-dir=.cvs; then
			GREP_OPTIONS="--color=auto --exclude-dir=$EXC_FOLDERS"
		elif grep-flags-available --color=auto --exclude=.cvs; then
			GREP_OPTIONS="--color=auto --exclude=$EXC_FOLDERS"
		fi

		if [[ -n "$GREP_OPTIONS" ]]; then
			# export grep, egrep and fgrep settings
			alias grep="grep $GREP_OPTIONS"
			alias egrep="grep -E $GREP_OPTIONS"
			alias fgrep="grep -F $GREP_OPTIONS"

			# write to cache file if cache directory is writable
			if [[ -w "$ZSH_CACHE_DIR" ]]; then
				alias -L grep egrep fgrep >| "$__GREP_CACHE_FILE"
			fi
		fi

		# Clean up
		unset GREP_OPTIONS EXC_FOLDERS
		unfunction grep-flags-available
	fi
	unset __GREP_CACHE_FILE __GREP_ALIAS_CACHES
}

# Changing/making/removing directory
{
	# setopt auto_cd
	# setopt auto_pushd
	# setopt pushd_ignore_dups
	# setopt pushdminus

	alias -g ...='../..'
	alias -g ....='../../..'
	alias -g .....='../../../..'
	alias -g ......='../../../../..'

	alias -- -='cd -'
	alias 1='cd -1'
	alias 2='cd -2'
	alias 3='cd -3'
	alias 4='cd -4'
	alias 5='cd -5'
	alias 6='cd -6'
	alias 7='cd -7'
	alias 8='cd -8'
	alias 9='cd -9'

	alias md='mkdir -p'
	alias rd=rmdir

	function d () {
	if [[ -n $1 ]]; then
		dirs "$@"
	else
		dirs -v | head -n 10
	fi
	}
	compdef _dirs d

	# List directory contents
	alias lsa='ls -lah'
	alias l='ls -lah'
	alias ll='ls -lh'
	alias la='ls -lAh'
}
