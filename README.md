Dot Files
=========

Repository for my system files. Consist of:

## gitconfig
My `gitconfig` file. To install

    ln -s ~/PATH_TO_DOTIFILED/gitconfig ~/.gitconfig

## gitignore_global
Global .gitignore file. To install type this in terminal:

    ln -s ~/PATH_TO_DOTIFILED/gitignore_global ~/.gitignore_global

and then change `excludefile` option in gitconfig

## zshrc
First of all we need to install ("OH MY
ZSH")[https://github.com/robbyrussell/oh-my-zsh]. To do this, simply run this
command:

    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

Configuration file for zsh console. To install:

    rm ~/.zshrc
    ln -s ~/PATH_TO_DOTIFILED/zshrc ~/.zshrc

## vim and vimrc
First of all init and update submodels for git, it need for vundle bundle:

    git submodule init
    git submodule update

Then link files:

    ln -s ~/PATH_TO_DOTIFILED/vim ~/.vim
    ln -s ~/PATH_TO_DOTIFILED/vimrc ~/.vimrc

## sf-cache
Little script which helps with Symfony primissions. To install system wild just
lynk it to user bin directory

    ln -s ~/PATH_TO_DOTIFILED/sf-cache /usr/local/bin/

Then make it executable
    
    chmod +x /usr/local/bin/sf-cache

## The end
End yes, its all for now.

