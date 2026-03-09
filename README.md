# Dotfiles — macOS / Linux 開發環境

使用 [GNU Stow](https://www.gnu.org/software/stow/) 管理 symlink，[Homebrew](https://brew.sh/) 管理套件。

> 首次安裝請參閱 [INSTALL.md](INSTALL.md)。
> Windows 設定請參閱 [README_WINDOWS.md](README_WINDOWS.md)。
> 快捷鍵總覽請參閱 [KEYMAP.md](KEYMAP.md)。

---

## 目錄結構

```
~/.dotfiles/
├── fish/          # Fish Shell 設定（別名、函式、快捷鍵）
├── nvim/          # Neovim 設定（Lazy.nvim 外掛管理）
├── tmux/          # tmux 設定（分割視窗、Session 管理）
├── starship/      # Starship 跨 Shell 提示符
├── ghostty/       # Ghostty 終端機設定
├── git/           # Git 設定（delta、別名）
├── lazygit/       # Lazygit TUI 設定
├── yazi/          # Yazi 檔案管理器
├── aerospace/     # AeroSpace 平鋪式視窗管理
├── karabiner*/    # Karabiner-Elements 鍵盤改鍵
├── bin/           # 自訂腳本
├── Brewfile       # Homebrew 套件清單
├── Brewfile_optional  # 額外套件
└── Brewfile_Me    # 個人套件
```

---

## 核心工具

| 工具 | 用途 | 主題 |
|------|------|------|
| **Fish** | 預設 Shell，別名、函式、自動補全 | — |
| **Neovim** | 主要編輯器，Lua 設定 + LSP | Nord (nordfox) |
| **tmux** | 終端多工器，Session/Window/Pane 管理 | Nord |
| **Starship** | 跨 Shell 提示符 | Nord |
| **Ghostty** | GPU 加速終端機 | Nord |
| **AeroSpace** | i3 風格平鋪式視窗管理 | — |
| **Lazygit** | Git TUI | Nord |
| **Yazi** | 終端檔案管理器 | Nord |

所有工具統一使用 **Nord** 配色主題，並統一採用 **Vim 風格（hjkl）** 的方向操作。

---

## Shell 常用指令與別名

### 導覽

| 別名 | 指令 | 說明 |
|------|------|------|
| `..` / `...` / `....` | `cd ..` / `cd ../..` / `cd ../../..` | 快速回上層 |
| `-` | `cd -` | 回前一個目錄 |
| `ls` | `eza` | 現代化 ls |
| `la` | `eza -a` | 顯示隱藏檔 |
| `ll` | `eza -l --icons` | 詳細列表 + 圖示 |
| `tree` | `eza --tree` | 樹狀顯示 |
| `y` | yazi | 檔案管理器（會追蹤目錄） |

### 編輯器與 AI

| 別名 | 指令 | 說明 |
|------|------|------|
| `v` | `nvim` | Neovim |
| `c` | `claude` | Claude Code |
| `cr` | `claude --resume` | 繼續上次 Claude 對話 |
| `g` | `gemini` | Gemini CLI |
| `lg` | `lazygit` | Git TUI |

### Git

| 別名 | 指令 | 說明 |
|------|------|------|
| `gp` | `git pull` | 拉取 |
| `gP` | `git push` | 推送 |
| `gc` | `git checkout` | 切換分支 |
| `ga` | `git-forgit add` | 互動式暫存 |
| `gd` | `git-forgit diff` | 互動式差異 |
| `glo` | `git-forgit log` | 互動式日誌 |
| `gcb` | `git-forgit checkout_branch` | 互動式切換分支 |
| `gss` | `git-forgit stash_show` | 互動式暫存檢視 |
| `gsp` | `git-forgit stash_push` | 互動式暫存推入 |

### 套件管理（pnpm）

| 別名 | 指令 | 說明 |
|------|------|------|
| `n` | `pnpm` | pnpm |
| `ni` | `pnpm install` | 安裝依賴 |
| `nd` | `pnpm dev` | 啟動開發伺服器 |
| `nb` | `pnpm build` | 建置 |
| `ns` | `pnpm start` | 啟動 |
| `nx` | `pnpm dlx` | 執行套件（等同 npx） |

### 系統維護

| 別名 | 說明 |
|------|------|
| `update` | 全面更新：git submodule、Homebrew、pnpm |
| `clean` | 清理：brew、rustup |
| `myip` | 查詢公開 IPv4 位址 |
| `cafe` | 切換 caffeinate（防止系統休眠，Starship 會顯示 ☕） |

### FZF 快捷鍵（在 Fish Shell 中）

| 快捷鍵 | 說明 |
|--------|------|
| `Ctrl+P` | 模糊搜尋並跳轉目錄（搜尋 dotfiles、projects 等路徑） |
| `Ctrl+R` | 搜尋指令歷史 |
| `Ctrl+G` | 搜尋 Git 日誌 |
| `Ctrl+X` | 搜尋行程 |

### 文字移動（Fish / Ghostty）

| 快捷鍵 | 說明 |
|--------|------|
| `Ctrl+F` | 向前跳一個字 |
| `Ctrl+B` | 向後跳一個字 |
| `Alt+P` / `Ctrl+E` | 向上搜尋 |
| `Alt+N` / `Ctrl+N` | 向下搜尋 |

---

## tmux 操作指南

### 基本概念

tmux 有三個層級：

1. **Session（會話）**：一組 Window 的集合，可以脫離（detach）後重新接上（attach）
2. **Window（視窗）**：類似瀏覽器的分頁，每個 Window 佔滿整個終端畫面
3. **Pane（窗格）**：在同一個 Window 內分割出的區塊

### Prefix 鍵

本設定的 **prefix 鍵是 `Ctrl-t`**（不是預設的 `Ctrl-b`）。

以下所有「`prefix + X`」表示：先按 `Ctrl-t` 放開，再按 `X`。

### Session 操作

| 操作 | 說明 |
|------|------|
| `t` | 啟動 tmux（Fish 別名） |
| `ta` | 接上最近的 Session（Fish 別名） |
| `tl` | 列出所有 Session（Fish 別名） |
| `tk <name>` | 刪除指定 Session（Fish 別名） |
| `prefix + N` | 在當前目錄建立新 Session |
| `prefix + w` | 樹狀選單，瀏覽並切換 Session / Window |
| `prefix + f` | 用 FZF 模糊搜尋並切換 Session（60% 彈出視窗） |
| `prefix + d` | 脫離（detach）目前的 Session |

### Window（視窗）操作

| 操作 | 說明 |
|------|------|
| `prefix + c` | 在當前目錄建立新 Window |
| `prefix + a` | 在當前目錄建立新 Window |
| `prefix + i` | 在最前面插入新 Window |
| `prefix + 0` | 建立新 Window 並移到第 1 個位置 |
| `prefix + .` | 在 `~/.dotfiles` 目錄開新 Window |
| `prefix + p` | 切換到上一個 Window |
| `prefix + Ctrl-t` | 切換到最後使用的 Window |
| `prefix + 1-9` | 切換到指定編號的 Window |
| `Ctrl+Shift+←/→` | 交換 Window 順序並切換過去 |

#### Window 命名

Window 名稱會自動切換，有兩種模式：

- **command 模式**（預設）：顯示目前執行的指令名稱
- **folder 模式**：顯示目前所在目錄名稱

| 操作 | 說明 |
|------|------|
| `prefix + m` | 在 command / folder 兩種命名模式之間切換 |

Fish Shell 的事件函式會自動處理 Window 標題更新：
- 執行指令時 → 顯示指令名稱（如 `nvim`、`lazygit`）
- 指令結束後 → 根據模式恢復為指令或目錄名稱

### Pane（窗格）操作

#### 建立窗格（分割畫面）

| 操作 | 說明 |
|------|------|
| `prefix + s` | 水平分割（上下排列） |
| `prefix + v` | 垂直分割（左右排列） |
| `prefix + -` | 水平分割（同 `s`） |
| `prefix + \` | 垂直分割（同 `v`） |

> 分割出的新窗格會繼承當前的工作目錄。

#### 窗格導覽

| 操作 | 說明 |
|------|------|
| `prefix + h` | 移動到左邊的窗格 |
| `prefix + j` | 移動到下方的窗格 |
| `prefix + k` | 移動到上方的窗格 |
| `prefix + l` | 移動到右邊的窗格 |
| `Ctrl + h/j/k/l` | **無需 prefix**，與 Neovim 無縫切換（透過 vim-tmux-navigator） |

`Ctrl + h/j/k/l` 可以在 tmux 窗格和 Neovim 分割視窗之間無縫移動，不需要區分目前在 tmux 還是 Neovim。

#### 調整窗格大小

| 操作 | 說明 |
|------|------|
| `Ctrl + ←/→/↑/↓` | 調整窗格大小（每次 5 單位，不需 prefix） |
| `prefix + z` | 暫時最大化 / 還原目前的窗格（zoom） |

#### 窗格管理

| 操作 | 說明 |
|------|------|
| `prefix + e` | 關閉除了目前窗格以外的所有窗格 |
| `prefix + B` | 將窗格拆出為獨立 Window |
| `prefix + J` | 把其他 Window 的窗格合併到當前 Window |
| `prefix + S` | 把當前窗格發送到其他 Session |
| `prefix + M` | 把當前窗格移動到其他 Session |
| `prefix + x` | 關閉當前窗格（會要求確認） |

#### 快速多窗格分割（Fish 函式）

| 函式 | 說明 |
|------|------|
| `w2` | 分割成 2 格（主區域 + 底部 20%） |
| `w3` | 分割成 3 格（左 + 右上 + 右下） |
| `w4` | 分割成 4 格（2×2 佈局） |

### 複製模式

tmux 使用 **Vi 風格** 的複製模式：

1. 進入複製模式：`prefix + [`
2. 用 hjkl 或其他 Vi 按鍵移動游標
3. 按 `v` 開始選取
4. 按 `Ctrl-v` 切換區塊選取（矩形選取）
5. 按 `y` 複製選取內容（會自動複製到系統剪貼簿）
6. 按 `q` 離開複製模式

> 透過 tmux-yank 外掛，複製的內容會同步到系統剪貼簿。

### Git 整合

| 操作 | 說明 |
|------|------|
| `prefix + g` | 用 FZF 瀏覽 Git 檔案（80% 彈出視窗） |

### 設定重載

| 操作 | 說明 |
|------|------|
| `prefix + r` | 重新載入 tmux 設定檔 |

### Session 自動儲存與恢復

透過 tmux-resurrect 和 tmux-continuum 外掛：

- 每 15 分鐘自動儲存所有 Session 狀態（Window 佈局、窗格、工作目錄）
- 重新開啟 tmux 時自動恢復上次的 Session
- Neovim 的 Session 也會一起恢復

### 滑鼠支援

滑鼠操作已啟用：
- 點擊窗格可切換焦點
- 拖曳窗格邊框可調整大小
- 滾輪可捲動歷史

### 閒置偵測

Window 有 5 秒的靜默偵測：
- 閒置的 Window 會在狀態列以綠色標示
- 主要用於多 agent 工作時辨別哪些 Window 已完成任務

### 狀態列

狀態列使用 Nord 配色：
- 左側：Session 名稱
- 中間：Window 列表（目前 Window 以藍色底色 `#88C0D0` 標示）
- 右側：`使用者名稱@主機名稱`

### 跨平台

- **macOS**：預設 Shell 為 `/opt/homebrew/bin/fish`（Apple Silicon）
- **Linux**：預設 Shell 為 `/usr/bin/fish` 或 `/home/linuxbrew/.linuxbrew/bin/fish`

### tmux 外掛

| 外掛 | 說明 |
|------|------|
| tmux-sensible | 合理的預設設定 |
| vim-tmux-navigator | tmux 窗格 ↔ Neovim 分割視窗無縫切換 |
| tmux-resurrect | Session 儲存與恢復 |
| tmux-continuum | 自動定期儲存 Session |
| tmux-yank | 複製到系統剪貼簿 |

---

## Neovim 操作指南

### Leader 鍵

Leader 鍵為 `\`（反斜線）。以下 `<leader>` 表示按 `\`，`<space>` 表示按空白鍵。

### 檔案與搜尋

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>sf` | 搜尋檔案（Telescope） |
| `<leader>sr` | 全文搜尋（live grep） |
| `<leader>sa` | 帶參數的 grep 搜尋 |
| `<leader>sw` | 搜尋游標下的字 |
| `<leader>sb` | 在目前 buffer 搜尋 |
| `<leader>sg` | 搜尋 Git 變更檔案 |
| `se` | Oil 檔案總管（浮動視窗） |
| `sf` | Oil 檔案總管 |

### 視窗管理（以 `s` 為前綴）

| 快捷鍵 | 說明 |
|--------|------|
| `ss` | 水平分割 |
| `sv` | 垂直分割 |
| `sh/sj/sk/sl` | 跳到 左/下/上/右 視窗 |
| `sq` | 關閉視窗 |
| `s=` | 平均分配所有視窗大小 |
| `sz` / `sM` | 最大化視窗 |
| `sp` | 切換到前一個視窗 |

### LSP 操作（以 `g` 為前綴）

| 快捷鍵 | 說明 |
|--------|------|
| `gd` | 跳到定義 |
| `gD` | 跳到宣告 |
| `gI` | 跳到實作 |
| `gr` | 查看參考 |
| `gR` | 重新命名符號 |
| `gca` | 程式碼動作 |
| `K` | 顯示文件 |
| `[d` / `]d` | 上/下一個診斷 |

### Git 操作（以 `gh` / `gb` 為前綴）

| 快捷鍵 | 說明 |
|--------|------|
| `ghs` | 暫存 hunk |
| `ghu` | 取消暫存 hunk |
| `ghr` | 重置 hunk |
| `gB` | 在瀏覽器開啟（GitHub） |
| `gp` / `gP` | Pull / Push |
| `]g` / `[g` | 下/上一個 hunk |
| `<space>gb` | 行內 blame |
| `<space>hp` | 預覽 hunk |

### 格式化與除錯

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>f` | 格式化目前檔案 |
| `<leader>l` | 執行 linter |
| `<space>b` | 切換中斷點 |
| `<space>c` | 繼續執行 |
| `<space>j/i/o` | Step over / into / out |
| `<space>w` | 切換 DAP UI |

### 快速執行

在不同語言檔案中按 `go` 可快速執行：
- Python → `python3`
- Fish → `fish`
- JavaScript → `node`
- TypeScript → `ts-node`
- Lua → `lua`
- C / C++ → 編譯並執行

### 其他

| 快捷鍵 | 說明 |
|--------|------|
| `<c-\>` | 切換浮動終端機 |
| `<c-s>` | 儲存檔案 |
| `<space>p` | Markdown 預覽 |
| `<space>z` | 切換自動換行 |
| `<leader>z` | 開啟 Lazy.nvim |

---

## AeroSpace 視窗管理

### 工作區

5 個工作區（1-5）+ 工作區 P（副螢幕，Google Chrome 自動移入）。

### 快捷鍵

| 快捷鍵 | 說明 |
|--------|------|
| `Alt + h/j/k/l` | 切換焦點到 左/下/上/右 |
| `Alt + Shift + h/j/k/l` | 移動視窗到 左/下/上/右 |
| `Alt + 1-5` | 切換到工作區 1-5 |
| `Alt + 0` | 切換到工作區 P |
| `Alt + Shift + 1-5` | 將視窗移到工作區 1-5 |
| `Alt + z` | 全螢幕 |
| `Alt + Shift + z` | 切換浮動/平鋪 |
| `Alt + Tab` | 切換到上一個工作區 |
| `Alt + Shift + Tab` | 將工作區移到下一個螢幕 |
| `Alt + /` | 切換佈局模式（tiles / accordion / horizontal） |
| `Alt + Shift + -/=` | 縮小/放大視窗 |

---

## Karabiner 鍵盤改鍵

| 原始按鍵 | 改為 | 說明 |
|----------|------|------|
| Caps Lock | Left Control | 更方便按 Ctrl 組合鍵 |
| Left Control | Fn | 原 Ctrl 位置改為 Fn |
| Right Cmd + h/j/k/l | ←/↓/↑/→ | 方向鍵（不離開主鍵區） |
| Ctrl + [ | Escape | Vim 風格的 Esc |
| Fn + h/j/k/l | ←/↓/↑/→ | 方向鍵替代 |

---

## Ghostty 終端機

- **字型**：JetBrainsMonoNL Nerd Font Mono，16pt
- **背景透明度**：90%，模糊效果
- **游標**：方塊，不閃爍
- **視窗標題**：隱藏（macOS）
- **特殊按鍵**：`Shift+Enter` 映射為特殊序列（供 Claude Code 使用）

---

## Starship 提示符

提示符顯示以下資訊：

- 使用者名稱 @ 主機名稱
- 當前目錄
- Git 分支與狀態（⇡ ahead、⇣ behind、? untracked、! modified、+ staged）
- 語言版本（Node.js、Python、Rust）
- 指令執行時間
- ☕ caffeinate 狀態
- ⏳ at 排程任務

成功時提示符為綠色 `>`，失敗時為紅色 `>`。

---

## Yazi 檔案管理器

### 快速跳轉

| 快捷鍵 | 目標 |
|--------|------|
| `g + d` | `~/.dotfiles` |
| `g + p` | `~/.z/projects` |
| `g + D` | `~/Downloads` |
| `g + c` | `~/.config` |
| `.` | 切換顯示隱藏檔 |
| `Ctrl+t` | 在當前目錄開啟 tmux 分割視窗 |

---

## 跨工具統一操作

### 方向導覽一致性

所有工具都使用 **hjkl**（Vim 風格）進行方向操作：

| 層級 | 切換焦點 | 分割 | 調整大小 |
|------|----------|------|----------|
| **Neovim** | `s + hjkl` | `ss` / `sv` | `sH/sJ/sK/sL` |
| **tmux** | `prefix + hjkl` 或 `Ctrl + hjkl` | `prefix + s/v` | `Ctrl + 方向鍵` |
| **AeroSpace** | `Alt + hjkl` | — | `Alt+Shift + -/=` |
| **Yazi** | `hjkl` | — | — |
| **Lazygit** | `hjkl` | — | — |

`Ctrl + hjkl` 可在 Neovim 和 tmux 之間**無縫切換**，不需要手動判斷目前在哪個環境。

### Nord 配色

幾乎所有終端工具都使用 Nord 主題，確保視覺一致性：
Ghostty、tmux 狀態列、Neovim (nordfox)、Lazygit、Yazi、Starship。

---

## 平台差異

| 項目 | macOS (Apple Silicon) | macOS (Intel) | Linux |
|------|----------------------|---------------|-------|
| Homebrew 路徑 | `/opt/homebrew` | `/usr/local` | `/home/linuxbrew/.linuxbrew` |
| Fish 路徑 | `/opt/homebrew/bin/fish` | `/usr/local/bin/fish` | `/usr/bin/fish` |
| 自動偵測 | ✅ `config.fish` 自動判斷 | ✅ | ✅ |

Fish 設定會根據 `uname` 和 `uname -m` 自動載入對應平台的設定檔：
- macOS → `config-osx.fish`
- Linux → `config-linux.fish`
