# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="frisk"
DEFAULT_USER="Sergey"

plugins=(git history symfony2 capistrano)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all
# Customize to your needs...
# aliaces
alias v='vim'
alias p='ping -c 5 ya.ru && ping -c 5 evercodelab.com && ping -c 5 github.com'
alias sf='app/console'
alias sfdc='php app/console doctrine:database:drop --force && php app/console doctrine:database:create'
alias sfdcmf='php app/console doctrine:database:drop --force && php app/console doctrine:database:create && php app/console doctrine:migrations:migrate --no-interaction && php app/console doctrine:fixtures:load --no-interaction'
alias sfdcm='php app/console doctrine:database:drop --force && php app/console doctrine:database:create && php app/console doctrine:migrations:migrate --no-interaction'
alias sfcc='rm -rf app/cache/* && php app/console cache:warmup && php app/console assetic:dump --force && php app/console assets:install'
alias gs='g s'
alias gps='g ps'
alias gpl='g pl'
alias gc='g c'
alias gu='g stash && g pl && g stash pop'
alias gsm='g a . && g a -u && gu && g c && g ps'
alias gsmd='g a . && g a -u && g stash && g pl && g stash pop && g c && g ps && cap deploy && cap prod deploy'
alias s='g a . && g a -u && g c && g ps'
alias mkdir='mkdir -p'
# Enable aliases to be sudo’ed
alias sudo='sudo '
# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Global aliaces
alias -g G="| grep"
alias -g L="| less"

# FUNCTIONS
# Add reminder to Reminders.app (OS X 10.8)
# Usage: `remind 'foo'` or `echo 'foo' | remind`
function remind() {
        local text
        if [ -t 0 ]; then
                text="$1" # argument
        else
                text=$(cat) # pipe
        fi
        osascript >/dev/null <<EOF
tell application "Reminders"
        tell the default list
                make new reminder with properties {name:"$text"}
        end tell
end tell
EOF
}

# Envs
# paths
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/php5/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
export PATH=/usr/local/php5-20120919-075914/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=./vendor/bin:$PATH
export PATH=./bin:$PATH
# editors
export EDITOR='vim'
export GIT_EDITOR='vim'
export SHELL='/bin/zsh'

eval "$(rbenv init -)"

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
