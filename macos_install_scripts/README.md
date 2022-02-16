```bash
# install xcode cmd
sudo xcode-select --install

# Setup ssh and github
ssh-keygen -t rsa -b 4096 -C “<userid>@gmail.com”

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Cmd programs
brew install python
brew install htop
brew install the_silver_searcher
brew install wget
brew install tmux
brew install fzf
brew install tree
brew install autopep8
brew install colordiff
brew install watch
brew install ispell
brew install mas  # Mac App Store command line interface
brew install speedtest-cli
brew install exiftool


brew tap railwaycat/emacsmacport
brew tap homebrew/cask-fonts
brew update


brew install --cask bettertouchtool
# brew install --cask font-source-code-pro
brew install --cask font-meslo-for-powerline
brew install --cask google-chrome
brew install --cask emacs-mac
brew install --cask iterm2
brew install --cask slack
brew install --cask spotify
brew install --cask discord
brew install --cask cyberduck
brew install --cask vlc
brew install --cask transmission
brew install --cask appcleaner
# brew install --cask disablemonitor
brew install --cask awareness
brew install --cask the-unarchiver
brew install --cask coconutbattery
brew install --cask disk-inventory-x
brew install --cask iina
brew install --cask docker
brew install --cask ultimaker-cura
brew install --cask fsnotes
brew install --cask michaelvillar-timer
brew install --cask messenger

brew install --cask mactex # require password

# MAS app store downloads
mas install 937984704 # Amphetamine

brew upgrade
brew cleanup

# Screenshots to Downloads
 defaults write com.apple.screencapture location ~/Downloads

# python stuff
pip install --upgrade autopep8

# Spacemacs
git clone -b develop https://github.com/syl20bnr/spacemacs ~/.emacs.d

# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Powerline10k
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc

# Dotfiles
git clone git@github.com:willxie/dotfiles.git ~/dotfiles

# Fzf setup
$(brew --prefix)/opt/fzf/install

# faster dock
defaults write com.apple.Dock autohide-delay -float 0.0001
defaults write com.apple.dock autohide-time-modifier -float 0.15
killall Dock
```

## Additional manual installs
```
Appstore:
Helium
WriteRoom
Exporter # Export apple notes to MD

# Change settings
caps lock to control: Keyboard -> modifier keys


# install refind
- disable sip in recovery: csrutil disable
- also in recovery secure boot off: https://support.apple.com/en-us/HT208330
- ./refind-install —alldrivers

auto brightness washed out / gamma fix:
# Disable SIP
cd /System/Library/PrivateFrameworks/AmbientDisplay.framework/Versions/A/XPCServices/com.apple.AmbientDisplayAgent.xpc/Contents/MacOS/
sudo mv com.apple.AmbientDisplayAgent _com.apple.AmbientDisplayAgent
# Enable SIP
# Reboot
```
