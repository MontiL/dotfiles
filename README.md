# Config for Mac / Linux

## Prerequirement

Apple's Command Line Tools for Git and Howbrew

```fish
xcode-select --install
```

[Install Homebrew (on macOS or Linux)](https://github.com/Homebrew/install)

```fish
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Git, Git-lfs

`brew install git git-lfs`

git large file storage, need to run this once per user account

`git lfs install`

## sync dotfiles

in git server

`git clone /Users/monti/repos/dotfiles.git ~/.dotfiles/`

in other server

```
ssh-copy-id monti@monti.local
git clone monti@/Users/monti/repos/dotfiles.git ~/.dotfiles/
```

## Homebrew

    cd ~/.dotfiles && brew bundle && brew cleanup && brew doctor

## fish shell

    ~/.config/fish && stow fish

[Set fish as default shell](https://gist.github.com/gagarine/cf3f65f9be6aa0e105b184376f765262)

in macOS Apple Silicon: /opt/homebrew/bin/fish, in macOS Intel CPU: /usr/local/bin/fish

1.  Add fish to the know shells:
    M1: `sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells'`
    Intel: `sudo sh -c 'echo /usr/local/bin/fish >> /etc/shells'`
2.  _Restart terminal_ and stow fish first
3.  Set fish as the default shell run the command:
    - M1: `chsh -s /opt/homebrew/bin/fish`
    - Intel: `chsh -s /usr/local/bin/fish`
4.  _Restart terminal_, and check if it launched with Fish

> PS: brew binaries in fish path is already add in `config.fish`: `set -U fish_user_paths /opt/homebrew/bin $fish_user_paths`

## Config for Neovim

Enter nvim `v` and wait for lsp to auto-install servers

<!-- Add LSP Server `:LspInstall bashls emmet_ls jsonls prosemd_lsp pylsp sumneko_lua tsserver vimls yamlls` -->

<!-- other LSP Server intelephense vuels  -->

DAP Setup

    https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Python
    https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Javascript
