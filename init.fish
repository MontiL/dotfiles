# run this script after: 
# 1. brew bundle (including fish shell)
# 2. ssh-keygen -f ~/.ssh/id_rsa -C "name_or_project@machine.local"

# disabled long-press globally
defaults write -g ApplePressAndHoldEnabled -bool false

# use node@20
brew link --overwrite node@20

echo 'change folder to .dotfiles'
cd ~/.dotfiles

echo 'stow config files'
rm -rf ~/.gitconfig && stow ssh tmux git nvim starship peco pylsp lazygit ghostty aerospace
ln -s ~/.dotfiles/bin/color_transfer /usr/local/bin/color_transfer

read -l -P 'Keyboard type to restore karabiner config: [1] Apple [2] Windows [3] K2 : ' foo
rm -rf ~/.config/karabiner/
switch $foo
    case 1
        stow karabiner_apple_keyboard
    case 2
        stow karabiner_windows_keyboard
    case 3
        stow karabiner_keychron_k2
end
# stow `cd ~/.dotfiles/AutoIMSwitch/; stow -t /usr/local/bin/ shell_script` 
echo 'stow Adobe Preferences'
stow -t ~/Library/Preferences/ adobe

# Fisher https://github.com/jorgebucaran/fisher
echo 'install plugins by fisher'
fisher update

# Fzf integration https://sourabhbajaj.com/mac-setup/iTerm/fzf.html
echo 'install pre-defined functions of fzf'
switch (uname -m)
    case arm64
        /opt/homebrew/opt/fzf/install
    case x86_64
        /usr/local/opt/fzf/install
end

# need to manually add keys if need to use ssh key for gitHub
# `ssh-add --apple-use-keychain ~/.ssh/id_rsa_xxx`
# https://dev.to/gauthierplm/fish-start-ssh-agent-on-session-opening-on-macos-2884
echo 'load ssh keys'
ssh-add --apple-use-keychain ~/.ssh/id_rsa
# TOOD: conditionally add keys
ssh-add --apple-use-keychain ~/.ssh/id_rsa_nutri
ssh-add --apple-use-keychain ~/.ssh/id_rsa_vege9
ssh-add --apple-use-keychain ~/.ssh/id_rsa_biandon
ssh-add --apple-use-keychain ~/.ssh/id_rsa_yushun
ssh-add --apple-use-keychain ~/.ssh/codecaba

#
# Restore packages and config
#

echo 'install pip packages'
pip install -r pip_requirements

echo 'install rust'
# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# extension
cargo install cargo-update prosemd-lsp

echo 'install nvm'
nvm install latest
nvm use latest

echo 'install node'
cat npm_requirements | xargs npm i -g

echo 'install Tmux TPM'
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo 'Press prefix + I (capital i, as in Install) to fetch the plugin.'
