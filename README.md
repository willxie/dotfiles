# Dotfiles

To install:

```
./install
```

OS specific options can be appended to the above line. E.g.:

```
./install osx_bash ...
```

MacOS example:

```
./install.sh gitconfig profile  tmux vim zsh spacemacs
```

```
# vscode
ln -s  ~/dotfiles/vscode/settings.json settings.json $HOME/Library/Application\ Support/Code/User/settings.json
```

Ubuntu example:

```
./install.sh zsh vim tmux profile
```
