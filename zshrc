# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bira"
DEFAULT_USER="sergeylunev"

DISABLE_AUTO_TITLE="true"
DISABLE_AUTO_UPDATE="true"

plugins=(git history symfony2 capistrano)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

# aliaces
alias v='vim'
alias p='ping -c 5 ya.ru && ping -c 5 evercodelab.com && ping -c 5 github.com'
alias sf='php app/console'
alias sfdc='php app/console doctrine:database:drop --force && php app/console doctrine:database:create'
alias sfdcmf='php app/console doctrine:database:drop --force && php app/console doctrine:database:create && php app/console doctrine:migrations:migrate --no-interaction && php app/console doctrine:fixtures:load --no-interaction'
alias sfdcm='php app/console doctrine:database:drop --force && php app/console doctrine:database:create && php app/console doctrine:migrations:migrate --no-interaction'
alias sfcc='rm -rf app/cache/* && php app/console cache:warmup && php app/console assetic:dump --force && php app/console assets:install'
alias sfge='php app/console doctrine:generate:entities'
alias sfgm='php app/console doctrine:migrations:diff && php app/console doctrine:migrations:migrate -n'
alias gs='git status -s'
alias gps='git push'
alias gpl='git pull --ff-only'
alias gc='git commit -va'
alias gu='git stash && git pull --ff-only && git stash pop'
alias gsm='git add -A && git stash && git pull --ff-only && git stash pop && git commit -va && git push'
alias s='git add -A && git stash && git commit -va && git push'
alias gcb='git remote update origin --prune && git branch --merged | grep -v "*" | xargs git branch -D'
alias mkdir='mkdir -p'
# Enable aliases to be sudo’ed
alias sudo='sudo '
# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Global aliaces
alias -g G="| grep"
alias -g L="| less"

# Envs
# paths
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/php5/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH
export PATH=/usr/local/php5-20120919-075914/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=./vendor/bin:$PATH
export PATH=./bin:$PATH
# editors
export EDITOR='vim'
export GIT_EDITOR='vim'
export SHELL='/bin/zsh'

HISTSIZE=100
SAVEHIST=100
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

zle -N predict-on
zle -N predict-off

bindkey "^R" history-incremental-search-backward
bindkey "^X^Z" predict-on   # C-x C-z
bindkey "^Z" predict-off    # C-z
bindkey "^F" forward-word
bindkey "^B" backward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
