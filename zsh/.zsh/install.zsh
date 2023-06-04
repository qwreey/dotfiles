[ ! -e "$HOME/.zsh/nvm" ] && git clone https://github.com/nvm-sh/nvm $HOME/.zsh/nvm --depth 1
[ ! -e "$HOME/.zsh/omz" ] && git clone https://github.com/ohmyzsh/ohmyzsh $HOME/.zsh/omz --depth 1
[ ! -e "$HOME/.zsh/defer" ] && git clone https://github.com/romkatv/zsh-defer $HOME/.zsh/defer --depth 1
[ ! -e "$HOME/.zsh/fnvm" ] && git clone https://github.com/qwreey75/fnvm $HOME/.zsh/fnvm --depth 1
[ ! -e "$HOME/.zsh/powerlevel10k" ] && git clone https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/powerlevel10k --depth=1
source $HOME/.zsh/rc.zsh
source $HOME/.zsh/lazyload.zsh
export NVM_DIR=$HOME/.zsh/nvm
source $HOME/.zsh/nvm/nvm.sh
omztrim; echo Trimmed zsh libs
zcompile_all; echo Recompiled all of zsh
echo Setup nodejs . . .
nvm install node
nvm version current > $HOME/.nvmrc.default
echo nodejs installed!
echo restarting . . .
exec zsh
