# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bira"

DISABLE_AUTO_TITLE="true"
DISABLE_AUTO_UPDATE="true"

plugins=(git history extract command-not-found zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

# aliases
alias v='nvim'
alias gs='git status -s'
alias gps='git push'
alias gpl='git pull --ff-only'
alias gc='git commit -va'
alias gu='git stash && git pull --ff-only && git stash pop'
alias gsm='git add -A && git commit -va && git push'
alias s='git add -A && git stash && git commit -va && git push'
alias gcb='git remote update origin --prune && git branch --merged | grep -v "*" | xargs git branch -D'
alias mkdir='mkdir -p'
# Enable aliases to be sudo'ed
alias sudo='sudo '

if [[ "$(uname -s)" == "Darwin" ]]; then
  # Show/hide hidden files in Finder
  alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
  alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
fi

# Global aliases
alias -g G="| grep"
alias -g L="| less"

# Envs
# paths
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
if [[ "$(uname -s)" == "Darwin" ]]; then
  export PATH=/opt/local/bin:$PATH
  export PATH=/opt/local/sbin:$PATH
fi
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin
# editors
export EDITOR='nvim'
export GIT_EDITOR='nvim'

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh/history
setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_no_store
setopt hist_no_functions
setopt no_hist_beep
setopt hist_save_no_dups
setopt auto_cd
setopt rmstarsilent
setopt autopushd
setopt pushd_ignore_dups

# Completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

bindkey "^R" history-incremental-search-backward
bindkey "^F" forward-word
bindkey "^B" backward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
[[ "$PATH" == *"$HOME/bin:"* ]] || export PATH="$HOME/bin:$PATH"
export PATH=$HOME/.local/bin:$PATH
