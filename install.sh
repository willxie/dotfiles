#!/bin/bash

# Variables
DOT_DIR=~/dotfiles
OLD_DOT_DIR=~/dotfiles_old
# "emacs tmux gitconfig vim profile"
MODULES=""

############# Script #############
# Add arguments to MODULES
for ARG in "$@"; do
    MODULES=$MODULES" "$ARG
done

echo "Modules:"
echo $MODULES

# Backup
echo -n "Creating $OLD_DOT_DIR to store backup of dotfiles in ~/ ..."
mkdir -p $OLD_DOT_DIR
echo "Done."

echo -n "cd to $DOT_DIR.. "
cd $DOT_DIR
echo "Done."

for MODULE in $MODULES; do
    cd $DOT_DIR/$MODULE
    for FILE in .*; do
        # Skip Mac non-sense
        if [ $FILE = ".DS_Store" ] || [ $FILE = "." ] || [ $FILE = ".." ] || [ $FILE = "*" ]; then
            continue
        fi
        # echo $FILE
        echo "Moving any old dot files $FILE..."
        mv ~/$FILE $OLD_DOT_DIR
        echo "Creating symlink to $MODULE in ~/"
        ln -s $DOT_DIR/$MODULE/$FILE ~/$FILE
    done
done

echo "All done."
