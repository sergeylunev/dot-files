# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
# aliaces
alias v='vim'
alias sf='app/console'

# Envs
# paths
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
export PATH=/usr/local/php5-20120919-075914/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export PATH=./vendor/bin:$PATH
export PATH=./bin:$PATH
# editors
export EDITOR='vim'
export GIT_EDITOR='vim'
export SHELL='/bin/zsh'

eval "$(rbenv init -)"

setopt APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS AUTO_CD BSD_ECHO PROMPT_SUBST
HISTSIZE=100
SAVEHIST=100
HISTFILE=~/.zsh/history
setopt append_history
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

zle -N predict-on
zle -N predict-off

bindkey "^R" history-incremental-search-backward
bindkey "^X^Z" predict-on   # C-x C-z
bindkey "^Z" predict-off    # C-z
bindkey "^F" forward-word
bindkey "^B" backward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
