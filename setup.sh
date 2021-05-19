#!/bin/bash
# this will only work on macOS for now.
# need to adjust this bootstrap for nixOS, WSL et al.
# 1. install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# 2. yadm
brew install yadm
# 3. clone dotfiles
yadm clone https://github.com/kvndrsslr/dotfiles.git
yadm submodule update --init --recursive
# 4. install from Brew
brew bundle install
# overwrite gpg link 
brew link --overwrite gnupg
# 5. install yabai scripting additions
sudo yabai --install-sa
# 6. start services
brew services start yabai
# 6. macOS defaults
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.Finder "AppleShowAllFiles" -bool "true"
defaults write com.apple.finder "QuitMenuItem" -bool "true"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0"
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write com.apple.appleseed.FeedbackAssistant "Autogather" -bool "false"
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"
defaults write com.apple.helpviewer "DevMode" -bool "true"
defaults write com.apple.screencapture "show-thumbnail" -bool "false"
defaults write com.apple.screencapture "location" -string "~/Pictures"
defaults write com.apple.screencapture "disable-shadow" -bool "true"
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock "tilesize" -int "36"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-timing-fuction -float 0.2
killall Finder
killall Dock
sudo yabai --load-sa

# perl init 
PERL_MM_OPT="INSTALL_BASE=$HOME/.local/share/perl5" cpan local::lib
brew link --overwrite perl
perl -MCPAN -e 'install Bundle::CPAN'
perl -MCPAN -e 'install App::cpanminus'

# might need to install svn from sources for git svn to work

# hotfix git svn 
sed -I '' -e 's/usr\/bin\/perl/usr\/local\/bin\/perl/g' $(brew --prefix git)/libexec/git-core/git-svn
cpanm Term::ReadKey

# symlinks

ln -s Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Knowledge/ ~/Knowledge
cd ~/Knowledge; git restore .; cd ~;


# asdf setup
asdf plugin add java
asdf install java adoptopenjdk-16.0.1+9
asdf global java adoptopenjdk-16.0.1+9
asdf plugin add maven
asdf install maven 3.8.1
asdf global maven 3.8.1
asdf plugin install python
asdf install python 3.9.5
asdf global python 3.9.5
asdf plugin add scala
asdf install scala 2.13.5
asdf global scala 2.13.5
asdf plugin add sbt
asdf install sbt 1.5.1
asdf global sbt 1.5.1
asdf plugin add nodejs
asdf install nodejs lts-erbium
asdf global nodejs lts-erbium
# python tools
pip3 install yeecli


asdf reshim