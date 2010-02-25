#!/bin/sh
#

# Create symlinks in $HOME to the appropriate files in this directory.

DOTFILES=".gitconfig .muttrc .vim .vimrc .zshrc"

for file in $DOTFILES; do
    ln -s .dotfiles/$file .
done

cd .ssh
ln -s ../.dotfiles/.ssh-config config
