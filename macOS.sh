#!/usr/bin/env zsh
set -e

xcode-select --install

echo "Complete the installation of Xcode Command Line Tools before proceeding."
echo "Press enter to continue..."
read

# Create Code directoriy in home
mkdir -p ${HOME}/Code

echo "Setting touchID as terminal authentication"
echo "Will need sudo password"
sudo cp -v /etc/pam.d/sudo /etc/pam.d/sudo.bak
sudo cp -v settings/sudo /etc/pam.d/

# Enable trackpad tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Set Dock to auto-hide
defaults write com.apple.dock autohide -bool true && killall Dock

# Set Dock icon size
defaults write com.apple.dock tilesize -int 42; killall Dock
defaults write com.apple.dock largesize -int 90; killall Doc
