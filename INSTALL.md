# 安裝指南

## 前置需求

安裝 Apple 命令列工具（提供 Git 與編譯工具）：

```bash
xcode-select --install
```

安裝 [Homebrew](https://github.com/Homebrew/install)：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 安裝 Git、Git LFS

```bash
brew install git git-lfs
git lfs install  # 每個使用者帳號執行一次
```

## 取得 dotfiles

本機：

```bash
git clone /Users/monti/repos/dotfiles.git ~/.dotfiles/
```

遠端：

```bash
ssh-copy-id monti@monti.local
git clone monti@/Users/monti/repos/dotfiles.git ~/.dotfiles/
```

## 安裝 Homebrew 套件

```bash
cd ~/.dotfiles && brew bundle && brew cleanup && brew doctor
```

額外套件（可選）：

```bash
brew bundle --file=Brewfile_optional
brew bundle --file=Brewfile_Me
```

## 設定 Fish Shell

用 stow 建立 symlink：

```bash
cd ~/.dotfiles && stow fish
```

[將 Fish 設為預設 Shell](https://gist.github.com/gagarine/cf3f65f9be6aa0e105b184376f765262)：

macOS Apple Silicon 路徑：`/opt/homebrew/bin/fish`
macOS Intel 路徑：`/usr/local/bin/fish`

1. 將 Fish 加入已知 Shell 清單：
   - Apple Silicon：`sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells'`
   - Intel：`sudo sh -c 'echo /usr/local/bin/fish >> /etc/shells'`
2. 重啟終端機
3. 設為預設 Shell：
   - Apple Silicon：`chsh -s /opt/homebrew/bin/fish`
   - Intel：`chsh -s /usr/local/bin/fish`
4. 重啟終端機，確認已啟動 Fish

> Fish 的 PATH 已在 `config.fish` 中設定好 Homebrew 路徑。

## 設定其他工具

用 stow 建立各工具的 symlink（從 `~/.dotfiles` 目錄執行）：

```bash
stow nvim       # Neovim
stow tmux       # tmux
stow starship   # Starship 提示符
stow ghostty    # Ghostty 終端機
stow git        # Git
stow lazygit    # Lazygit
stow yazi       # Yazi 檔案管理器
stow karabiner  # Karabiner-Elements 鍵盤改鍵
stow aerospace  # AeroSpace 視窗管理
```

> 提示：先用 `stow --simulate <package>` 模擬確認不會有衝突，再正式執行。

## 設定 Neovim

開啟 Neovim（`v`），Lazy.nvim 會自動安裝所有外掛，Mason 會自動安裝 LSP 伺服器。

## 設定 tmux

開啟 tmux 後按 `prefix + I`（即 `Ctrl-t` 再按 `I`）安裝 TPM 外掛。

## 設定 Claude Code

用 stow 建立 symlink：

```bash
stow claude-code
```

設定 git filter，避免 Claude Code CLI 每次啟動改寫 `settings.json`
（key 順序、`model`、`feedbackSurveyState`、`agentPushNotifEnabled`）
造成的雜訊 diff（每個 repo clone 執行一次）：

```bash
git config filter.claude-settings.clean "jq --sort-keys 'del(.model, .feedbackSurveyState, .agentPushNotifEnabled)'"
git config filter.claude-settings.smudge cat
```

## API 金鑰

API 金鑰放在 `fish/.config/fish/api-keys.fish`，此檔案不追蹤於 Git。
請自行建立並填入需要的金鑰。
