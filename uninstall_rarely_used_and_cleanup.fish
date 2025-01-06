brew uninstall flyctl
brew uninstall vimr
brew uninstall emscripten
brew uninstall iterm2

brew uninstall pyenv-virtualenv
brew uninstall pyenv
brew uninstall python@3.9
brew uninstall ipython
brew uninstall bpython

brew uninstall go
brew uninstall rbenv
brew uninstall ruby-build

brew uninstall subversion

brew uninstall ffmpegthumbnailer
brew uninstall ffmpeg@4

brew uninstall helix
brew uninstall turso

brew uninstall zsh
brew uninstall zsh-syntax-highlighting
brew uninstall font-hack-nerd-font

# Uninstall formulae that were only installed as a dependency of another formula and are now no longer needed.
brew autoremove
# Remove stale lock files and outdated downloads for all formulae and casks, and remove old versions of installed formulae. If arguments are specified, only do this for the given formulae and casks. Removes all downloads more than 120 days old. This can be adjusted with HOMEBREW_CLEANUP_MAX_AGE_DAYS.
brew cleanup
