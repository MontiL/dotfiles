# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for macOS/Linux development environment configuration. It uses GNU Stow for symlink management and Homebrew for package management.

## Essential Commands

### Setup & Installation

```bash
# Install packages from Brewfile
cd ~/.dotfiles && brew bundle && brew cleanup && brew doctor

# Set up fish shell configuration
cd ~/.config/fish && stow fish

# Set up dotfiles with stow (run from specific config directories)
stow <package-name>  # e.g., stow nvim, stow tmux
```

### Development Workflow

```bash
# Update system and packages
update  # alias for comprehensive system update

# Clean system caches
clean   # alias for cleanup operations

# Git operations (common aliases available)
g       # git
gp      # git pull
gP      # git push
gc      # git checkout
lg      # lazygit
```

### Package Management

```bash
# Node.js/pnpm (primary package manager)
n       # pnpm
ni      # pnpm install
nb      # pnpm build
nd      # pnpm dev
ns      # pnpm start
nx      # pnpm dlx (equivalent to npx)

# Homebrew management
brew bundle        # install from Brewfile
brew bundle dump   # update Brewfile
```

## Architecture & Structure

### Configuration Management

- **Stow-based**: Each tool has its own directory with proper symlink structure
- **Modular design**: Individual configs for nvim, tmux, fish, etc.
- **Platform-aware**: Separate configs for macOS (`config-osx.fish`) and Linux (`config-linux.fish`)

### Key Directories

- `nvim/`: Neovim configuration with Lazy.nvim plugin manager
- `fish/`: Fish shell configuration with extensive aliases and functions
- `tmux/`: tmux configuration with custom key bindings (prefix: Ctrl-t)
- `starship/`: Cross-shell prompt configuration
- `bin/`: Custom scripts and utilities

### Shell Environment (Fish)

- **Default shell**: Fish with extensive customization
- **Package managers**: Homebrew (primary), pnpm (Node.js), cargo (Rust)
- **Key tools**: neovim, tmux, fzf, eza, bat, ripgrep, lazygit
- **Navigation**: zoxide for smart directory jumping
- **Prompt**: Starship for consistent prompt across shells

### Development Stack

- **Editor**: Neovim with Lua configuration
- **Terminal multiplexer**: tmux with custom keybindings
- **Version control**: Git with delta for diffs, lazygit for TUI
- **Package managers**: Homebrew, pnpm, cargo, pip
- **Languages**: Node.js (v20), Python (3.10-3.12), Rust, Ruby

### tmux Configuration

- **Prefix key**: `Ctrl-t` (not default Ctrl-b)
- **Pane navigation**: Vim-like hjkl bindings
- **Split commands**: `s` (horizontal), `v` (vertical)
- **Session management**: Automatic window renaming based on running command

### Homebrew Setup

- **Main Brewfile**: Core development tools and applications
- **Optional Brewfile**: Additional packages (`Brewfile_optional`)
- **Personal Brewfile**: User-specific packages (`Brewfile_Me`)

## Important Notes

### API Keys & Secrets

- API keys are loaded from `fish/.config/fish/api-keys.fish`
- This file is not tracked in git (should be added to .gitignore)
- Never commit sensitive information

### Platform Differences

- Fish config automatically detects macOS vs Linux
- Homebrew paths differ between Intel (`/usr/local`) and Apple Silicon (`/opt/homebrew`)
- Some aliases and paths are platform-specific

### Stow Usage

- Always run stow commands from the specific package directory
- Use `stow --no-folding` if you need to avoid directory folding
- Test stow operations with `--simulate` flag first

### tmux Integration

- Automatic window renaming based on running commands
- Fish shell integration for command-based window titles
- Custom status bar with user@hostname display

