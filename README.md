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
Configuration file for zsh console. To install:

    ln -s ~/PATH_TO_DOTIFILED/zshrc ~/.zshrc

## vim and vimrc
First of all init and update submodels for git, it need for vundle bundle:

    git submodule init
    git submodule update

Then link files:

    ln -s ~/PATH_TO_DOTIFILED/vim ~/.vim
    ln -s ~/PATH_TO_DOTIFILED/vimrc ~/.vimrc

## The end
End yes, its all for now.

