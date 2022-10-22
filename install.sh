#!/bin/bash

# Variables
HOME_DIR="${HOME}"
DOT_DIR=$HOME_DIR/dotfiles
OLD_DOT_DIR=$HOME_DIR/dotfiles_old
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
echo "Creating $OLD_DOT_DIR to store backup of dotfiles."
mkdir -p $OLD_DOT_DIR

echo "cd to $DOT_DIR."
cd $DOT_DIR

for MODULE in $MODULES; do
    cd $DOT_DIR/$MODULE
    DEST_DIR="${HOME_DIR}"
    # Custom location for some modules
    if [ $MODULE  == "cura" ]; then
        DEST_DIR="${HOME_DIR}/Library/Application Support"
    fi

    # Copy back up files and copy
    for FILE in *; do
        # Skip Mac non-sense
        if [ $FILE = ".DS_Store" ] || [ $FILE = "." ] || [ $FILE = ".." ] || [ $FILE = "*" ]; then
            continue
        fi
        # Back up old file
        if [ -f "$DEST_DIR/$FILE" ]; then
            echo "Moving any old dot files $FILE..."
            mv $DEST_DIR/$FILE $OLD_DOT_DIR
        fi
        echo "Creating symlink to $MODULE in ${DEST_DIR}/"
        echo "$DOT_DIR/$MODULE/$FILE"
        echo "${DEST_DIR}/$FILE"
        ln -s "$DOT_DIR/$MODULE/$FILE" "$DEST_DIR/$FILE"
    done
done

echo "All done."
