#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks (Apps)
# And also sets up VS Code
# And also sets up Oh My Zsh and Powerlevel10k
############################

# dotfiles directory
dotfiledir="${HOME}/dotfiles"

# list of files/folders to symlink in ${homedir}
files=(zshrc bashrc bash_profile bash_prompt aliases functions vimrc)

# change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# create symlinks (will overwrite old dotfiles)
for file in "${files[@]}"; do
    echo "Creating symlink to ${file} in home directory."
    ln -sf "${dotfiledir}/.${file}" "${HOME}/.${file}"
done

# Run the MacOS Script
./macOS.sh

# Run the Zsh Script
./zsh.sh

# Run the Homebrew Script
./brew.sh

# Run VS Code Script
./vscode.sh

# Manual installs from App Store
echo "---------------------------"
echo "| Install from App Store: |"
echo "---------------------------"
echo
echo " (1) BetterSnapTool (https://apps.apple.com/de/app/bettersnaptool/id417375580?mt=12)"
echo "Press enter to continue..."
read
echo " (4) Hidden Bar (https://apps.apple.com/de/app/hidden-bar/id1452453066?mt=12)"
echo "Press enter to continue..."
echo "Press enter to continue..."
read

echo
echo "Copy your SSH config manually..."
echo "Press enter to continue..."
echo "Press enter to continue..."
read

echo
echo "Installation Complete!"
