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
    mkdir ~/.zsh

## vim and vimrc
First, we need to install vundle, which would handle plugin managment for us.

    $ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Then link files:

    ln -s ~/PATH_TO_DOTIFILED/vimrc ~/.vimrc

Next steep install plugins in vim:

    :BundleInstall

## Some usefull scripts
You can find them in `bin` directory. To use system wild just create symbolik
link for `bin` directory in your home folder:

    ln -s ~/PATH_TO_DOTIFILED/bin ~

## The end
End yes, its all for now.
