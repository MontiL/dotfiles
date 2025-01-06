# Lower priority stuff ...

## Windows Manager and keyboard utility

[yabai](<https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)>)

[skhd](https://github.com/koekeishiya/skhd)

brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd
brew services start yabai skhd

<!-- extra config: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition -->

Known issues

- skhd: could not lock pid-file! https://github.com/koekeishiya/skhd/issues/74

## pyenv

execute this interactively:

```fish
set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
# check $PATH
echo $PATH
# check fish_variables
v ~/.dotfiles/fish/.config/fish/fish_variables
```

## Vim setup

```fish
# Install packer for Neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# Command to install plugins
v ~/.dotfiles/dotconfig/nvim/lua/plugins.lua
:w<CR>

# Check health and fix errors
:checkhealth
```

## Latex

mactex: `brew install mactex`

latexmk:

```fish
# https://mg.readthedocs.io/latexmk.html
# re-activate terminal first
sudo tlmgr update --self
sudo tlmgr install latexmk

In NeoVim:
: LspInstall latex
```

[SpaceLauncherApp](https://spacelauncherapp.com/)

```fish
brew install spacelauncher
```

powershell

```fish
brew install powershell

In NeoVim:
: LspInstall powershell_es
```

## TODO

- Learn how to use [default](https://macos-defaults.com/#%F0%9F%99%8B-what-s-a-defaults-command) to record and restore System preferences and other macOS configuraitons.
- Organize these growing steps into multiple script files
- Automate syslinking and run script files with a bottstrapping tool like [Dotbot](https://github.com/anishathalye/dotbot).
- Revisit the list in [`.zshrc`](.zshrc) to customize the shell.
- Make a checklist of steps to decommission your computer before wiping your hard drive.
- Create a [bootable USB installer for macOS](https://support.apple.com/en-us/HT201372).
- Integrate other cloud service into your Dotfiles process (Dropbox, Google Drive , etc.).
- Find inspiration and example in other Doffiles repositories at https://dotfiles.github.io.
- And last, but hopefully not least, [take my course, Dotfiles from Start to Finish-ish](https://www.udemy.com/course/dotfiles-from-start-to-finish-ish/?referralCode=445BE0B541C48FE85276 'Learn Dotfiles from Start to Finish-ish on Udemy')!

## Reference

- <https://github.com/craftzdog/dotfiles-public>
- <https://github.com/nickjj/dotfiles>

## Other

### Zsh

- [zsh-completions](https://github.com/zsh-users/zsh-completions)

```fish
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
```

- [zsh-zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

```fish
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- [powerlevel10k](https://github.com/romkatv/powerlevel10k#getting-started)

```fish
p10k configure
```

### Integrating with powerline fonts https://github.com/powerline/fonts

```fish
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
```

### Oh-My-Tmux

```fish
# Install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Symbolic Links
ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/.tmux.conf.local ~/.tmux.conf.local
```

## Hide desktop of macOS

```fish
defaults write com.apple.finder CreateDesktop false
killall Finder
```
