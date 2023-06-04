DEBUG=false
$DEBUG && timer1=$(($(date +%s%N)/1000000)) && echo .zshrc load started

# ----------------------  CONFIG  ----------------------
export HISTFIL=$HOME/.zsh/history
export FNVM_NVMDIR=$HOME/.zsh/nvm
export FNVM_DIR=$HOME/.zsh/fnvm
export NVM_DIR=$HOME/.zsh/nvm

# load defer
source $HOME/.zsh/defer/zsh-defer.plugin.zsh

# nvm
zsh-defer +1 +2 -c 'source $HOME/.zsh/fnvm/fnvm.sh; fnvm_init'
# lazyload
zsh-defer +1 +2 source $HOME/.zsh/lazyload.zsh
[ -e "$HOME/.zsh/user-before.zsh" ] && zsh-defer +1 +2 source $HOME/.zsh/user-lazy.zsh

# user config
DISABLE_AUTO_TITLE="true" # more performance!
DISABLE_UNTRACKED_FILES_DIRTY="true"
[ -e "$HOME/.zsh/user-before.zsh" ] && source $HOME/.zsh/user-before.zsh

# ----------------------  ZSH  ----------------------
$DEBUG && timer2=$(($(date +%s%N)/1000000))
export ZSH="$HOME/.zsh/omz"
export ZSH_CUSTOM="$ZSH/custom"
export ZSH_CACHE_DIR="$ZSH/cache"
[ -z "$plugins" ] && plugins=( git copyfile copypath ) # git web-search copypath copyfile copybuffer dirhistory

mkdir -p "$ZSH_CACHE_DIR/completions"

# add a function path
fpath=("$ZSH/functions" "$ZSH/completions" $fpath)
autoload -U compaudit compinit zrecompile

is_plugin() {
	local base_dir=$1
	local name=$2
	builtin test -f $base_dir/plugins/$name/$name.plugin.zsh \
		|| builtin test -f $base_dir/plugins/$name/_$name
}

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
	if is_plugin "$ZSH_CUSTOM" "$plugin"; then
		fpath=("$ZSH_CUSTOM/plugins/$plugin" $fpath)
	elif is_plugin "$ZSH" "$plugin"; then
		fpath=("$ZSH/plugins/$plugin" $fpath)
	else
		echo "[oh-my-zsh] plugin '$plugin' not found"
	fi
done

# Save the location of the current completion dump file.
ZSH_COMPDUMP="$HOME/.zsh/zcompdump-${ZSH_VERSION}.zsh"

# Construct zcompdump OMZ metadata
zcompdump_revision="#omz revision: $(builtin cd -q "$ZSH"; git rev-parse HEAD 2>/dev/null)"
zcompdump_fpath="#omz fpath: $fpath"

# Delete the zcompdump file if OMZ zcompdump metadata changed
if ! command grep -q -Fx "$zcompdump_revision" "$ZSH_COMPDUMP" 2>/dev/null \
	|| ! command grep -q -Fx "$zcompdump_fpath" "$ZSH_COMPDUMP" 2>/dev/null; then
	command rm -f "$ZSH_COMPDUMP*"
	zcompdump_refresh=1
	echo -n "Updating zcomdump file ..."
	tee -a "$ZSH_COMPDUMP" &>/dev/null <<EOF

$zcompdump_revision
$zcompdump_fpath
EOF
	compinit -C -i -d "$ZSH_COMPDUMP"
	zrecompile -q -p "$ZSH_COMPDUMP"
	echo " (done)"
fi
unset zcompdump_revision zcompdump_fpath zcompdump_refresh

source "$ZSH/lib/compfix.zsh"
compinit -i -d "$ZSH_COMPDUMP"
handle_completion_insecurities &|

_omz_source() {
	local context filepath="$1"

	# Construct zstyle context based on path
	case "$filepath" in
	lib/*) context="lib:${filepath:t:r}" ;;         # :t = lib_name.zsh, :r = lib_name
	plugins/*) context="plugins:${filepath:h:t}" ;; # :h = plugins/plugin_name, :t = plugin_name
	esac

	# local disable_aliases=0
	# zstyle -T ":omz:${context}" aliases || disable_aliases=1

	# Back up alias names prior to sourcing
	# local -A aliases_pre galiases_pre
	# if (( disable_aliases )); then
	# 	aliases_pre=("${(@kv)aliases}")
	# 	galiases_pre=("${(@kv)galiases}")
	# fi

	# Source file from $ZSH_CUSTOM if it exists, otherwise from $ZSH
	if [[ -f "$ZSH_CUSTOM/$filepath" ]]; then
		source "$ZSH_CUSTOM/$filepath"
	elif [[ -f "$ZSH/$filepath" ]]; then
		source "$ZSH/$filepath"
	fi

	# Unset all aliases that don't appear in the backed up list of aliases
	# if (( disable_aliases )); then
	# 	if (( #aliases_pre )); then
	# 		aliases=("${(@kv)aliases_pre}")
	# 	else
	# 		(( #aliases )) && unalias "${(@k)aliases}"
	# 	fi
	# 	if (( #galiases_pre )); then
	# 		galiases=("${(@kv)galiases_pre}")
	# 	else
	# 		(( #galiases )) && unalias "${(@k)galiases}"
	# 	fi
	# fi
}

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for config_file ("$ZSH"/lib/*.zsh); do
	_omz_source "lib/${config_file:t}"
done
unset custom_config_file

autoload -U colors && colors
autoload -Uz is-at-least
autoload -Uz +X regexp-replace VCS_INFO_formats
autoload -Uz add-zsh-hook
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt multios
setopt long_list_jobs
setopt interactivecomments
setopt prompt_subst

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
	_omz_source "plugins/$plugin/$plugin.plugin.zsh"
done
unset plugin

# Load all of your custom configurations from custom/
for config_file ("$ZSH_CUSTOM"/*.zsh(N)); do
	source "$config_file"
done
unset config_file

# set completion colors to be the same as `ls`, after theme has been loaded
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

$DEBUG && echo "oh my zsh loaded: "$(($(date +%s%N)/1000000-$timer2))

# ----------------------  THEME  ----------------------
$DEBUG && timer3=$(($(date +%s%N)/1000000))
source $HOME/.zsh/p10k.zsh
source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
$DEBUG && echo "theme loaded: "$(($(date +%s%N)/1000000-$timer3))

# ----------------------  AFTER  ----------------------
[ -e "$HOME/.zsh/user-after.zsh" ] && source $HOME/.zsh/user-after.zsh
$DEBUG && echo "SUM: "$(($(date +%s%N)/1000000-$timer1))
true
