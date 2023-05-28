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
./install.sh gitconfig profile spacemacs tmux vim zsh cura p10k
```
```
# vscode
ln -s  ~/dotfiles/vscode/settings.json settings.json $HOME/Library/Application\ Support/Code/User/settings.json
```

Ubuntu example:

```
./install.sh zsh vim ubuntu_ros_bash tmux spacemacs profile i3
```
