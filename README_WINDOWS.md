# Config for Windows

## Prerequisites

[scoop](https://scoop.sh/)

```PowerShell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
<!-- Invoke-WebRequest get.scoop.sh | Invoke-Expression -->
irm get.scoop.sh | iex
```

[Git for Windows](https://git-scm.com/download/win)

```PowerShell
scoop install git git-lfs
winget install --id Git.Git -e --source winget

<!-- New-Item -ItemType SymbolicLink -Path ~/.gitconfig -Target ~/.dotfiles/.gitconfig -->
<!-- New-Item -ItemType SymbolicLink -Path ~/.gitattributes -Target ~/.gitattributes -->
cp ~/.dotfiles/.gitconfig ~/.gitconfig
cp ~/.dotfiles/.gitattributes ~/.gitattributes
```

Update PowerShell

```PowerShell
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
```

[Windows Terminal](https://github.com/microsoft/terminal)

```PowerShell
scoop bucket add extras
<!-- scoop install windows-terminal -->
winget install --id=Microsoft.WindowsTerminal -e
```

[Rust](https://forge.rust-lang.org/infra/other-installation-methods.html)

```PowerShell
# Install Rust
<!-- On Windows, download and run rustup-init.exe. -->
<!-- https://static.rust-lang.org/rustup/dist/i686-pc-windows-gnu/rustup-init.exe -->
scoop install rust
rustup toolchain install stable-x86_64-pc-windows-gnu
rustup default stable-x86_64-pc-windows-gnu

# Install stylua by cargo
cargo install stylua
```

nvm

```PowerShell
scoop install nvm
nvm list available
nvm install <VERSION>
npm i -g commitizen neovim prettier remark tree-sitter-cli
```

<!-- [pyenv-win](https://github.com/pyenv-win/pyenv-win) -->
<!---->
<!-- ```PowerShell -->
<!-- Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1" -->
<!---->
<!-- 1. Add PYENV, PYENV_HOME and PYENV_ROOT to your Environment Variables -->
<!-- [System.Environment]::SetEnvironmentVariable('PYENV',$env:USERPROFILE + "\.pyenv\pyenv-win\","User") -->
<!-- [System.Environment]::SetEnvironmentVariable('PYENV_ROOT',$env:USERPROFILE + "\.pyenv\pyenv-win\","User") -->
<!-- [System.Environment]::SetEnvironmentVariable('PYENV_HOME',$env:USERPROFILE + "\.pyenv\pyenv-win\","User") -->
<!---->
<!-- 2. Now add the following paths to your USER PATH variable in order to access the pyenv command. Run the following in PowerShell or Windows 8/above Terminal: -->
<!-- [System.Environment]::SetEnvironmentVariable('path', $env:USERPROFILE + "\.pyenv\pyenv-win\bin;" + $env:USERPROFILE + "\.pyenv\pyenv-win\shims;" + [System.Environment]::GetEnvironmentVariable('path', "User"),"User") -->
<!---->
<!-- 3. Close and reopen your terminal app and run pyenv --version -->
<!---->
<!-- pyenv update -->
<!-- pyenv install <VERSION> -->
<!-- ``` -->

<!-- Execute Shell Script file using WSL -->
<!---->
<!-- ```PowerShell -->
<!-- Go to Settings > Update & Security > For Developers. -->
<!-- Check the Developer Mode radio button. ' -->
<!-- And search for “Windows Features”, choose “Turn Windows features on or off”. -->
<!-- ``` -->

## Install tools by Scoop

[Oh-My-Posh](https://ohmyposh.dev/docs/installation/windows)

```PowerShell
scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
# For the PATH to be reloaded, a restart of your terminal is advised.
scoop install posh-git
Add-PoshGitToProfile
```

[Nerd Font](https://github.com/ryanoasis/nerd-fonts)

```PowerShell
Download and install fonts:
https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
```

[packer for Neovim](https://github.com/wbthomason/packer.nvim)

```PowerShell
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
# Command to install plugins
v ~/.dotfiles/dotconfig/nvim/lua/plugins.lua
:w<CR>
```

Utility

```PowerShell
scoop install curl fd ripgrep zoxide
scoop install sudo jq
```

Terminal Icons

```PowerShell
Install-Module -Name Terminal-Icons

# Add this line in user_profile.ps1 of powershell:
# Import-Module Terminal-Icons
```

Coding

```PowerShell
scoop install python vscode

scoop install neovim gcc llvm make yarn
New-Item -ItemType SymbolicLink -Path ~\AppData\Local\nvim -Target ~\.dotfiles\dotconfig\nvim\

# LSP Server
:LspInstall bashls emmet_ls intelephense jsonls powershell_es prosemd_lsp pyright sumneko_lua tsserver vimls vuels yamlls
:LspInstallServer vscode-json-language-server

# DAP Setup
https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Python
https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Javascript
```

Z: Directory jumper

```PowerShell
Install-Module -Name z
```

[PSReadLine: Autocompletion](https://github.com/PowerShell/PSReadLine)

```PowerShell
Install-Module PSReadLine -AllowPrerelease -Force
```

[Fzf: Fuzzy finder](https://github.com/junegunn/fzf)

```PowerShell
scoop install fzf
Install-Module -Name PSFzf
```

[keymap tool](https://github.com/randyrants/sharpkeys)
[keystroke tool](http://code52.org/carnac/)

```PowerShell
scoop install sharpkeys carnac
```

[AutoHotkey](https://github.com/Lexikos/AutoHotkey_L)

```PowerShell
scoop install autohotkey
```

## User profile

link to .dotfiles

```PowerShell
New-Item -ItemType SymbolicLink -Path ~\.config\powershell -Target ~\.dotfiles\dotconfig\powershell\
```

Activate profile of powershell

```PowerShell
nvim $PROFILE.CurrentUserCurrentHost
# then, in nvim:
. $env:USERPROFILE\.config\powershell\user_profile.ps1
```

## Latex

```PowerShell
scoop install perl miktex
```

## Other

[Install Linux on Windows with WSL](https://docs.microsoft.com/en-us/windows/wsl/install)
[Tmux on Windows](https://codeandkeep.com/Tmux-on-Windows/)
