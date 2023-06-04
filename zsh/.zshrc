export FPATH="$HOME/.cache:$HOME/.zsh:$HOME/.zsh/defer:$HOME/.zsh/fnvm:$HOME/.zsh/nvm:$HOME/.zsh/powerlevel10k:$HOME/.zsh/powerlevel10k/gitstatus:$HOME/.zsh/powerlevel10k/internal:$FPATH"
if [[ -r "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source $HOME/.zsh/rc.zsh
# FNVM NOUPDATE
