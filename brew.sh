#!/usr/bin/env zsh
set -e

# Install Homebrew if it isn't already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Attempt to set up Homebrew PATH automatically for this session
    if [ -x "/opt/homebrew/bin/brew" ]; then
        # For Apple Silicon Macs
        echo "Configuring Homebrew in PATH for Apple Silicon Mac..."
        export PATH="/opt/homebrew/bin:$PATH"
    fi
else
    echo "Homebrew is already installed."
fi

# Verify brew is now accessible
if ! command -v brew &>/dev/null; then
    echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
    exit 1
fi

# Update Homebrew and Upgrade any already-installed formulae
brew update
brew upgrade
brew upgrade --cask
brew cleanup

# Define an array of packages to install using Homebrew.
packages=(
    "bat"
    "python"
    "git"
    "tree"
    "bash"
    "zsh"
    "pylint"
    "black"
    "node"
    "wireguard-go"
    "gh"
    "vim"
)

# Loop over the array to install each application.
for package in "${packages[@]}"; do
    if brew list --formula | grep -q "^${package}\$"; then
        echo "${package} is already installed. Skipping..."
    else
        echo "Installing ${package}..."
        brew install "${package}"
    fi
done

# Add the Homebrew zsh to allowed shells
echo "Changing default shell to Homebrew zsh"
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells >/dev/null
# Set the Homebrew zsh as default shell
chsh -s "$(brew --prefix)/bin/zsh"

# Git config name
echo "Please enter your FULL NAME for Git configuration:"
read git_user_name

# Git config email
echo "Please enter your EMAIL for Git configuration:"
read git_user_email

# Set my git credentials
$(brew --prefix)/bin/git config --global user.name "$git_user_name"
$(brew --prefix)/bin/git config --global user.email "$git_user_email"

echo "Copy config from ${HOME}/dotfiles/settings/gitconfig to ~/.gitconfig"
read

# Install Prettier, which I use in both VS Code and Sublime Text
$(brew --prefix)/bin/npm install --global prettier

# Define an array of applications to install using Homebrew Cask.
apps=(
    "1password"
    "google-chrome"
    "google-drive"
    "thonny"
    "tor-browser"
    "visual-studio-code"
    "gimp"
    "vlc"
    "docker"
    "iterm2"
    "dropbox"
    "beekeeper-studio"
)

# Loop over the array to install each application.
for app in "${apps[@]}"; do
    if brew list --cask | grep -q "^$app\$"; then
        echo "$app is already installed. Skipping..."
    else
        echo "Installing $app..."
        brew install --cask "$app"
    fi
done

# Tool to create dynamic wallpapers
# https://github.com/mczachurski/wallpapper
brew tap mczachurski/wallpapper
brew install wallpapper

# Set dynamic wallpapers (light/dark)
echo "Open ${HOME}/dotfiles/settings/wallpaper.json and update the path to the wallpaper images."
read

IMAGE_PATH="${HOME}/dotfiles/settings/Desktop.heic"
wallpapper -i "${HOME}/dotfiles/settings/wallpaper.json" \
           -o "${IMAGE_PATH}"

# AppleScript command to set the desktop background
echo "Setting desktop background..."
osascript <<EOF
tell application "System Events"
    set desktopCount to count of desktops
    repeat with desktopNumber from 1 to desktopCount
        tell desktop desktopNumber
            set picture to "${IMAGE_PATH}"
        end tell
    end repeat
end tell
EOF

# Install Source Code Pro Font
# Tap the Homebrew font cask repository if not already tapped
brew tap | grep -q "^homebrew/cask-fonts$" || brew tap homebrew/cask-fonts

# Define the font name
font_name="font-source-code-pro"

# Check if the font is already installed
if brew list --cask | grep -q "^$font_name\$"; then
    echo "$font_name is already installed. Skipping..."
else
    echo "Installing $font_name..."
    brew install --cask "$font_name"
fi

# Once font is installed, Import your Terminal Profile
echo "Import your terminal settings..."
echo "iTerm2 -> Settings -> Profiles -> Import..."
echo "Import from ${HOME}/dotfiles/settings/iterm2-profile.json"
echo "Make default setting"
echo "Press enter to continue..."
read

# Update and clean up again for safe measure
brew update
brew upgrade
brew upgrade --cask
brew cleanup

echo "Sign in to 1Password. Press enter to continue..."
read

echo "Sign in to Google Chrome. Press enter to continue..."
read

echo "Sign in to Dropbox. Press enter to continue..."
read
