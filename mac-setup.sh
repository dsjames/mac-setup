
# Ask for the administrator password upfront.
sudo -v

eval $(/opt/homebrew/bin/brew shellenv)

#Install Rosetta 2
arch=$(/usr/bin/arch)

if [ "$arch" == "arm64" ]; then
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install XCode Command Line Tools
echo 'Checking to see if XCode Command Line Tools are installed...'
brew config

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Cleaning up brew"
brew cleanup

#Install Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

#Install x86 homebrew & Python

if [ "$arch" == "arm64" ]; then
  arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  alias ibrew="arch -x86_64 /usr/local/bin/brew"
  ibrew install python@3.9
else
  brew install python@3.9
fi

# Install Powerline fonts
echo "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git
cd fonts || exit
sh -c ./install.sh
cd
rm -r fonts
 
brew install romkatv/powerlevel10k/powerlevel10k
#Replace the below line with dot file
#echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
git clone git://github.com/zsh-users/zsh-autosuggestions.git


# Apps
apps=(
  alfred
  bartender
  bettertouchtool
  google-chrome
  iterm2
  vlc
  microsoft-office
  microsoft-teams
  istat-menus
  1password
  visual-studio-code
  soundsource
)

# Install apps to /Applications
echo "installing apps with Cask..."
brew install --cask --appdir="/Applications" ${apps[@]}

#Install mas-cli
brew install mas

#Install speedtest CLI
brew tap teamookla/speedtest
brew install speedtest --force

brew cleanup

#Install Todo
mas install 1212616790

#Install Amphetamine
mas install 937984704


# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

#Install Python Virtual Environment

pip install virtualenv
pip install virtualenvwrapper
mkdir .envs

#Copy .zshrc from github

echo "Copying dotfiles from Github"
cd ~
curl https://raw.githubusercontent.com/dsjames/mac-setup/main/.zshrc > .zshrc
source $HOME/.zshrc
