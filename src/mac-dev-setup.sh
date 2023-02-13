#!/bin/bash

# Create a folder who contains downloaded things for the setup
INSTALL_FOLDER=~/.macsetup
mkdir -p $INSTALL_FOLDER
MAC_SETUP_PROFILE=$INSTALL_FOLDER/macsetup_profile

# install brew
if ! hash brew
then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
else
  printf "\e[93m%s\e[m\n" "You already have brew installed."
fi

# CURL / WGET
brew install curl
brew install wget

{
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/curl/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"'
}>>$MAC_SETUP_PROFILE

# git
brew install git

# ZSH
brew install zsh zsh-completions
sudo chmod -R 755 /usr/local/share/zsh
sudo chown -R root:staff /usr/local/share/zsh
{
  echo "if type brew &>/dev/null; then"
  echo "  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH"
  echo "  autoload -Uz compinit"
  echo "  compinit"
  echo "fi"
} >>$MAC_SETUP_PROFILE


# Install oh-my-zsh on top of zsh to getting additional functionality
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# Pimp command line
brew install micro                                                                                    # replacement for nano/vi
brew install lsd                                                                                      # replacement for ls
{
  echo "alias ls='lsd'"
  echo "alias l='ls -l'"
  echo "alias la='ls -a'"
  echo "alias lla='ls -la'"
  echo "alias lt='ls --tree'"
} >>$MAC_SETUP_PROFILE

brew install tree
brew install ack
brew install bash-completion
brew install jq
brew install htop
brew install tldr
brew install coreutils
brew install watch

brew install z
touch ~/.z
echo '. /usr/local/etc/profile.d/z.sh' >> $MAC_SETUP_PROFILE

brew install ctop

# Browser
brew install --cask google-chrome
brew install --cask brave
brew install --cask microsoft-edge

# Music / Video
brew install --cask spotify
brew install --cask vlc

# Dev tools
brew install --cask postman                                                                             # Postman makes sending API requests simple.

# IDE
brew install --cask visual-studio-code

# Language
## Node / Javascript
mkdir ~/.nvm
brew install nvm                                                                                     # choose your version of npm
nvm install node                                                                                     # "node" is an alias for the latest version

## python
echo "export PATH=\"/usr/local/opt/python/libexec/bin:\$PATH\"" >> $MAC_SETUP_PROFILE
brew install python
pip install --user pipenv
pip install --upgrade setuptools
pip install --upgrade pip
brew install pyenv
# shellcheck disable=SC2016
echo 'eval "$(pyenv init -)"' >> $MAC_SETUP_PROFILE

# Databases
brew install --cask dbeaver-community
brew install libpq                  # postgre command line
brew link --force libpq

# shellcheck disable=SC2016
echo 'export PATH="/usr/local/opt/libpq/bin:$PATH"' >> $MAC_SETUP_PROFILE

# Docker
brew install --cask docker
brew install bash-completion
brew install docker-completion
brew install docker-compose-completion
brew install docker-machine-completion

# reload profile files.
{
  echo "source $MAC_SETUP_PROFILE # alias and things added by mac_setup script"
}>>"$HOME/.zsh_profile"
# shellcheck disable=SC1090
source "$HOME/.zsh_profile"

{
  echo "source $MAC_SETUP_PROFILE # alias and things added by mac_setup script"
}>>~/.bash_profile
# shellcheck disable=SC1090
source ~/.bash_profile
