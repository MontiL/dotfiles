# fish/.config/fish/config.fish

set -g fish_greeting # disable greeting message

set -gx EDITOR nvim
set -gx HOMEBREW_NO_AUTO_UPDATE 1
# $TERM is set by tmux (tmux-256color) — don't override here
# Ghostty sets TERMINFO to its own directory, which only contains ghostty entries.
# Inside tmux, TERM is tmux-256color and tools like termbox can't find it there.
# Erase TERMINFO inside tmux so the system terminfo database is used instead.
if set -q TMUX
    set -e TERMINFO
end

# theme
# ------------------------------------------------------------
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes

# language setting (git or other app will need this config)
# ------------------------------------------------------------
set -g LANG en_US
set --export --global LESSCHARSET utf-8
set -x LC_ALL en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# project paths
# ------------------------------------------------------------
set -g capy ~/.z/projects/capybara/
set -g dotfile ~/.dotfiles/

set -gx COLORTERM truecolor
# aliases
# ------------------------------------------------------------
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
abbr -a -- - 'cd -'

alias cls clear
alias gp "git pull" # pull from remote
alias gP "git push" # push to remote
alias wp "git fetch origin dev && git rebase FETCH_HEAD" # pull from worktree (rebase for linear history)
alias wP "git push origin dev" # push dev to remote
function d2m --description "Fast-forward main to dev and push"
    echo "Updating main to dev..."
    git fetch . dev:main
    or return 1
    echo "Pushing main to origin..."
    git push origin main
    echo "Done."
end
function d2t --description "Fast-forward test to dev and push"
    echo "Updating test to dev..."
    git fetch . dev:test
    or return 1
    echo "Pushing test to origin..."
    git push origin test
    echo "Done."
end
function d2a --description "Fast-forward test+main to dev and push"
    echo "Updating test to dev..."
    git fetch . dev:test
    or return 1
    echo "Updating main to dev..."
    git fetch . dev:main
    or return 1
    echo "Pushing test+main to origin..."
    git push origin test main
    echo "Done."
end
function ws --description "Worktree sync: rebase agents onto dev, push dev, then sync agents back"
    set -l root ~/.z/projects/capybara
    set -l dev "$root/www"
    set -l dev_head_before (git -C "$dev" rev-parse HEAD)
    # 0. Integrate remote dev first — another machine may have pushed
    echo "Fetching origin dev..."
    git -C "$dev" fetch origin dev
    or begin
        echo "  ⚠ fetch origin dev failed"
        return 1
    end
    set -l remote_ahead (git -C "$dev" rev-list --count dev..FETCH_HEAD 2>/dev/null)
    if test "$remote_ahead" -gt 0
        echo "Remote dev is $remote_ahead ahead, rebasing local dev..."
        git -C "$dev" rebase FETCH_HEAD
        or begin
            echo "  ⚠ dev rebase conflict — resolve in $dev then re-run ws"
            return 1
        end
    end
    # 1. Rebase each agent branch onto dev, then fast-forward merge into dev
    for n in 1 2 3 4 5
        set -l agent_dir "$root/agent$n"
        if test -d "$agent_dir"
            set -l ahead (git -C "$dev" rev-list --count dev..agent$n 2>/dev/null)
            if test "$ahead" -gt 0
                echo "Rebasing agent$n onto dev ($ahead commits)..."
                git -C "$agent_dir" rebase dev
                or begin
                    echo "  ⚠ Rebase conflict in agent$n — resolve manually then re-run ws"
                    return 1
                end
                echo "Fast-forward merging agent$n into dev..."
                git -C "$dev" merge agent$n
            end
        end
    end
    # 2. Push dev to remote (self-healing against a race with another machine)
    echo "Pushing dev to origin..."
    if not git -C "$dev" push origin dev
        echo "Push rejected — re-fetching and rebasing dev, then retrying..."
        git -C "$dev" fetch origin dev
        and git -C "$dev" rebase FETCH_HEAD
        and git -C "$dev" push origin dev
        or begin
            echo "  ⚠ dev push still failing — resolve manually in $dev"
            return 1
        end
    end
    # 3. Sync agents back to latest dev via rebase (+ pnpm install / prisma generate if changed)
    for n in 1 2 3 4 5
        set -l agent_dir "$root/agent$n"
        if test -d "$agent_dir"
            set -l behind (git -C "$agent_dir" rev-list --count agent$n..dev 2>/dev/null)
            if test "$behind" -gt 0
                set -l agent_head (git -C "$agent_dir" rev-parse HEAD)
                echo "Rebasing agent$n onto dev ($behind behind)..."
                git -C "$agent_dir" rebase dev
                or echo "  ⚠ agent$n sync rebase failed — run: cd $agent_dir && git rebase dev"
                set -l pkg_diff (git -C "$agent_dir" diff --name-only $agent_head..HEAD -- "package.json" 2>/dev/null | head -1)
                if test -n "$pkg_diff"
                    echo "  package.json changed, installing dependencies..."
                    fish -c "cd $agent_dir && pnpm install"
                end
                set -l schema_diff (git -C "$agent_dir" diff --name-only $agent_head..HEAD -- "prisma/schema/" 2>/dev/null | head -1)
                if test -n "$schema_diff"
                    echo "  Prisma schema changed, regenerating client..."
                    fish -c "cd $agent_dir && pnpm prisma generate"
                end
            end
        end
    end
    # 4. Clear eslint cache across all worktrees if config/deps changed
    set -l dev_pkg_diff (git -C "$dev" diff --name-only $dev_head_before..HEAD -- "package.json" 2>/dev/null | head -1)
    set -l dev_eslint_diff (git -C "$dev" diff --name-only $dev_head_before..HEAD -- "eslint.config.mjs" 2>/dev/null | head -1)
    if test -n "$dev_pkg_diff" -o -n "$dev_eslint_diff"
        echo "ESLint config/deps changed, clearing lint caches..."
        rm -f "$dev/.eslintcache"
        for n in 1 2 3 4 5
            rm -f "$root/agent$n/.eslintcache"
            for w in 1 2 3 4 5
                rm -f "$root/workers/a$n/w$w/.eslintcache"
            end
        end
        for w in 1 2 3 4 5
            rm -f "$root/workers/dev/w$w/.eslintcache"
        end
    end
    echo "Done."
end
function __is_sync_target_machine --description "True on machines that are themselves sync targets (imac / Mia 的 mba)"
    # imac：用機型辨識
    switch (sysctl -n hw.model 2>/dev/null)
        case 'iMac*'
            return 0
    end
    # Mia 的 mba：用登入帳號辨識
    test (whoami) = mia
end

function wss --description "Worktree sync + fast-forward test & main to dev and push"
    ws
    or return 1
    d2a
    or return 1
    # 通知 capy 重新部署 diagnostic-agent（連不到就跳過、不擋 wss）
    # 先走區網 IP（各機都用 ssh-copy-id 佈好金鑰）；連不上才退回 capy alias
    if command -q ssh
        echo "Deploying diagnostic-agent to capy..."
        ssh -o ConnectTimeout=5 -o BatchMode=yes capy@192.168.68.200 deploy-agent
        set -l rc $status
        # 255 = ssh 本身連不上（不是 deploy-agent 失敗），才值得換一條路重試
        if test $rc -eq 255
            ssh -o ConnectTimeout=5 -o BatchMode=yes capy deploy-agent
            set rc $status
        end
        test $rc -eq 0
        or echo "  ⚠ capy deploy skipped (capy 連不到或 deploy-agent 失敗)"
    end
    # 同步專案 + dotfiles 到 imac（連不到就跳過、不擋 wss）
    # 在 imac / Mia 的 mba 上跑時不需要再同步回自己
    if __is_sync_target_machine
        echo "Skipping dev env sync (本機就是同步目標)."
    else
        echo "Syncing dev env to imac..."
        fish ~/.z/projects/capybara/www/scripts/sync-dev-env.fish imac
        or echo "  ⚠ imac sync skipped (連不到或同步失敗)"
    end
end

# Worker Pool Functions
# ============================================================
# Architecture: workers/{dev,a1-a5}/w{1-5}
# Ports: dev=3010+w-1, agent=3000+N*100+10+w-1
# Usage: wc a1 3, wrm a1 3, wsync a1 3, wca a1, wrma a1

function __pool_resolve --description "Resolve parent dir, branch, rel_path for pool worker"
    set -l parent $argv[1]
    set -l root ~/.z/projects/capybara
    switch $parent
        case dev
            echo "$root/www"
            echo dev
            echo "../../../www"
        case a1 a2 a3 a4 a5
            set -l n (string sub -s 2 $parent)
            echo "$root/agent$n"
            echo "agent$n"
            echo "../../../agent$n"
        case '*'
            echo "Error: invalid parent '$parent' (use: dev, a1-a5)" >&2
            return 1
    end
end

function wc --description "Create a pool worker worktree: wc <parent> <num>"
    if test (count $argv) -ne 2
        echo "Usage: wc <parent> <num> (e.g., wc a1 3)"
        return 1
    end

    set -l parent $argv[1]
    set -l num $argv[2]
    set -l root ~/.z/projects/capybara
    set -l resolved (__pool_resolve $parent) || return 1
    set -l parent_dir $resolved[1]
    set -l parent_branch $resolved[2]
    set -l rel_path $resolved[3]
    set -l worker_dir "$root/workers/$parent/w$num"
    set -l branch
    set -l port

    # Branch name: dev-w1 or a1w1
    switch $parent
        case dev
            set branch "dev-w$num"
        case '*'
            set branch "$parent"w"$num"
    end

    # Port: dev=3010+w-1, agent=3000+N*100+10+w-1
    switch $parent
        case dev
            set port (math 3010 + $num - 1)
        case '*'
            set -l n (string sub -s 2 $parent)
            set port (math 3000 + $n \* 100 + 10 + $num - 1)
    end

    if test -d "$worker_dir"
        echo "Worker $worker_dir already exists"
        return 1
    end

    echo "Creating worker: $branch (port $port) from $parent_branch..."

    # 1. Create worktree
    git -C "$parent_dir" worktree add "$worker_dir" -b "$branch" "$parent_branch"
    or return 1

    # 2. Symlink node_modules
    ln -s "$rel_path/node_modules" "$worker_dir/node_modules"

    # 3. Copy .env and change NEXTAUTH_URL port
    cp "$parent_dir/.env" "$worker_dir/.env"
    sed -i '' "/^NEXTAUTH_URL/s|localhost:[0-9]*|localhost:$port|" "$worker_dir/.env"

    # 4. Install dependencies & generate prisma client
    fish -c "cd $worker_dir && pnpm install && pnpm prisma generate"

    echo "✓ Worker $branch ready at $worker_dir (port $port)"
end

function wrm --description "Remove a pool worker worktree: wrm <parent> <num>"
    if test (count $argv) -ne 2
        echo "Usage: wrm <parent> <num>"
        return 1
    end

    set -l parent $argv[1]
    set -l num $argv[2]
    set -l root ~/.z/projects/capybara
    set -l resolved (__pool_resolve $parent) || return 1
    set -l parent_dir $resolved[1]
    set -l worker_dir "$root/workers/$parent/w$num"
    set -l branch

    switch $parent
        case dev
            set branch "dev-w$num"
        case '*'
            set branch "$parent"w"$num"
    end

    if not test -d "$worker_dir"
        echo "Worker $worker_dir does not exist"
        return 1
    end

    echo "Removing worker: $branch..."
    rm -f "$worker_dir/node_modules"
    git -C "$parent_dir" worktree remove "$worker_dir" --force
    git -C "$parent_dir" branch -D "$branch" 2>/dev/null
    echo "✓ Worker $branch removed"
end

function wsync --description "Sync pool worker with parent branch: wsync <parent> <num>"
    if test (count $argv) -ne 2
        echo "Usage: wsync <parent> <num>"
        return 1
    end

    set -l parent $argv[1]
    set -l num $argv[2]
    set -l root ~/.z/projects/capybara
    set -l resolved (__pool_resolve $parent) || return 1
    set -l parent_branch $resolved[2]
    set -l worker_dir "$root/workers/$parent/w$num"
    set -l branch

    switch $parent
        case dev
            set branch "dev-w$num"
        case '*'
            set branch "$parent"w"$num"
    end

    if not test -d "$worker_dir"
        echo "Worker $worker_dir does not exist"
        return 1
    end

    set -l old_head (git -C "$worker_dir" rev-parse HEAD)
    echo "Rebasing $branch onto $parent_branch..."
    git -C "$worker_dir" rebase "$parent_branch"

    set -l schema_diff (git -C "$worker_dir" diff --name-only $old_head..HEAD -- "prisma/schema/" 2>/dev/null | head -1)
    if test -n "$schema_diff"
        echo "  Prisma schema changed, regenerating..."
        fish -c "cd $worker_dir && pnpm prisma generate"
    end

    set -l pkg_diff (git -C "$worker_dir" diff --name-only $old_head..HEAD -- "package.json" 2>/dev/null | head -1)
    set -l eslint_diff (git -C "$worker_dir" diff --name-only $old_head..HEAD -- "eslint.config.mjs" 2>/dev/null | head -1)
    if test -n "$pkg_diff" -o -n "$eslint_diff"
        if test -f "$worker_dir/.eslintcache"
            echo "  ESLint config/deps changed, clearing lint cache..."
            rm -f "$worker_dir/.eslintcache"
        end
    end

    echo "✓ Worker $branch synced"
end

function wca --description "Create all 5 workers for a parent: wca <parent>"
    if test (count $argv) -ne 1
        echo "Usage: wca <parent> (e.g., wca a1)"
        return 1
    end
    for n in 1 2 3 4 5
        wc $argv[1] $n
    end
end

function wrma --description "Remove all workers for a parent: wrma <parent>"
    if test (count $argv) -ne 1
        echo "Usage: wrma <parent> (e.g., wrma a1)"
        return 1
    end
    for n in 1 2 3 4 5
        wrm $argv[1] $n 2>/dev/null
    end
end

alias agents "pgrep -af claude | grep -v grep | wc -l | string trim"
alias gc 'git checkout'
alias lg lazygit

alias gg "ghq get"
alias v nvim
alias c claude
alias cr "claude --resume"
alias cx "codex --sandbox danger-full-access"
alias cxr "codex resume --sandbox danger-full-access"
alias g gemini
alias gg='source ~/gemini-bot/venv/bin/activate.fish && python3 ~/gemini-bot/chat.py'
alias gr "gemini --resume"
alias gpp "gemini --model gemini-3-pro-preview"
alias gfp "gemini --model gemini-3-flash-preview"

alias n pnpm
alias nd "pnpm dev"
alias nx "pnpm dlx" # pnpm dlx is same as pnpx and npx
alias ni "pnpm install"
alias niD "pnpm install -D"
alias nu "pnpm uninstall"
alias nb "pnpm build"
alias ns "pnpm start"
alias nbs "pnpm build && pnpm start"
alias nig "pnpm install --global"
alias nid "pnpm install && pnpm dev"
alias np "pnpm prisma migrate dev && pnpm prisma generate"
function format
    begin
        git diff --name-only --diff-filter=ACMR -z
        git ls-files --others --exclude-standard -z
    end | grep -zE '\.(js|jsx|ts|tsx|css|scss|json|md)$' | xargs -0 pnpm prettier --write
end

alias vimdiff "v -d"

alias t tmux # can follow by session name
alias ta "tmux attach"
alias tk "tmux kill-session -t" # can follow by session name
alias tl "tmux list-sessions"
alias tw "tmux new-session -n agent1 -c ~/.z/projects/capybara/agent1 \; new-window -n agent2 -c ~/.z/projects/capybara/agent2 \; new-window -n agent3 -c ~/.z/projects/capybara/agent3 \; new-window -n agent4 -c ~/.z/projects/capybara/agent4 \; new-window -n agent5 -c ~/.z/projects/capybara/agent5 \; new-window -n www -c ~/.z/projects/capybara/www/ \; new-window -n www -c ~/.z/projects/capybara/www/"
alias tws "tmux new-session -c ~/.z/projects/capybara/www/ \; new-window \; split-window -v 'pnpm dlx @agentdeskai/browser-tools-server' \; select-pane -U"

alias ls eza
alias l eza
alias la "ls -a"
alias ll "ls -l --icons"
alias lla "ll -a"
alias tree "eza --tree"
alias rg "rg -i"
alias free "free -m" # show sizes in MB
alias df "df -h" # human-readable sizes
alias x 'gxargs -d "\n"'
alias mkdir 'mkdir -p'

# Security
alias pc proxychains4
alias myip 'dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com'

# `brew update` must run first so `brew bundle` sees fresh formula data and can
# actually upgrade what the Brewfile pins. Steps are `;`-separated so one failing
# step does not skip the rest.
alias update "cd ~/.dotfiles/ && git submodule update --init; brew update; brew bundle; brew upgrade; brew autoremove; pnpm update -g; ~/.dotfiles/bin/alacritty-build"
alias clean "brew cleanup -s && rustup update"
alias clean_chrome "rm -rf /Users/"(whoami)"/Library/Caches/Google/Chrome/* && rm -rf /Users/"(whoami)"/Library/Application\ Support/Google/Chrome/Profile\ *"

alias block 'block_unblock block'
alias unblock 'block_unblock unblock'

alias himonti "ngrok tcp 22"
alias mchost "ngrok tcp 25565"

alias done "terminal-notifier -message 'finished' -sound default; killall caffeinate"

function y
    yazi $argv
end

# yazi wrapper - cd to last browsed directory on exit
function yc
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set -q tmp; and test -n (cat "$tmp"); and test (cat "$tmp") != (pwd)
        cd (cat "$tmp")
    end
    rm -f "$tmp"
end

# PATH setting
# ------------------------------------------------------------
fish_add_path -gm ~/.local/bin # to be checked first
fish_add_path -g ~/.dotfiles/bin
fish_add_path -g ~/.cargo/bin
# rbenv
fish_add_path -g ~/.rbenv/shims
fish_add_path -g ~/.gem
# Go
fish_add_path -g /usr/local/go/bin
fish_add_path -g ~/go/bin
# pg_dump / pg_restore
fish_add_path /opt/homebrew/opt/libpq/bin

# PostgreSQL 15
fish_add_path /opt/homebrew/opt/postgresql@15/bin

switch (uname)
    case Darwin
        set -gx NODE_EXTRA_CA_CERTS "/private/etc/ssl/cert.pem"
        source ~/.dotfiles/fish/.config/fish/config-osx.fish
    case Linux
        set -gx NODE_EXTRA_CA_CERTS "/etc/ssl/certs/ca-certificates.crt"
        if test -x /home/linuxbrew/.linuxbrew/bin/brew
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        end
        source ~/.dotfiles/fish/.config/fish/config-linux.fish
end

# Colorful man pages
# ------------------------------------------------------------
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\033[01;32m")

# zoxide
zoxide init fish | source

# Starship
starship init fish | source

# Bat
#   show available themes:
#   bat --list-themes | fzf --preview="bat --theme={} --color=always /path/to/file"
set -x BAT_THEME DarkNeon

# Fzf
fzf_configure_bindings --directory=\cs --history=\cr --process=\cx --git_log=\cg # --git_status=\cs
set fzf_fd_opts --hidden --exclude=.git #--bind=ctrl-/:toggle-preview fzf --preview='cat {}'
# alt-s: same directory search as ctrl-s, but also includes .gitignore-d files (photos etc.)
bind \es _fzf_search_directory_all
set fzf_preview_file_cmd "fzf --preview 'cat {}' --preview-window right:90%:hidden:wrap --bind ctrl-/:toggle-preview"

# pnpm
switch (uname)
    case Darwin
        set -gx PNPM_HOME "$HOME/Library/pnpm"
    case Linux
        set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
# 把 PNPM_HOME 與其 bin/ 子目錄都加進 PATH
# （不同 pnpm 版本/設定的 global-bin-dir 可能是 $PNPM_HOME 或 $PNPM_HOME/bin，
#  兩個都加可避免 "global bin directory is not in PATH" 警告）
for __p in $PNPM_HOME $PNPM_HOME/bin
    if not contains -- $__p $PATH
        set -gx PATH $__p $PATH
    end
end
set -e __p
# pnpm end

# fnm (after PNPM_HOME so fnm's node path takes priority)
if type -q fnm
    fnm env --use-on-cd --shell fish | source
end

# Added by Windsurf
if test -d $HOME/.codeium/windsurf/bin
    fish_add_path $HOME/.codeium/windsurf/bin
end

# Gemini
set -gx GEMINI_MODEL gemini-3-pro-preview

# Added by LM Studio CLI (lms)
if test -d $HOME/.cache/lm-studio/bin
    fish_add_path -a $HOME/.cache/lm-studio/bin
end

# Load API keys (not tracked in git, may not exist on every machine)
if test -f $HOME/.dotfiles/fish/.config/fish/api-keys.fish
    source $HOME/.dotfiles/fish/.config/fish/api-keys.fish
end

function __tmux_rename_window --on-event fish_preexec
    if test -n "$TMUX"
        set -l mode (tmux show-option -gqv @window_name_mode)
        if test "$mode" = "command"
            set -l cmd (string split " " $argv[1])[1]
            tmux rename-window $cmd
        end
    end
end

function __tmux_restore_window --on-event fish_postexec
    if test -n "$TMUX"
        set -l mode (tmux show-option -gqv @window_name_mode)
        if test "$mode" = "command"
            tmux rename-window "fish"
        else
            tmux rename-window (basename $PWD)
        end
    end
end

function __tmux_update_folder_name --on-variable PWD
    if test -n "$TMUX"
        set -l mode (tmux show-option -gqv @window_name_mode)
        if test "$mode" != "command"
            tmux rename-window (basename $PWD)
        end
    end
end

# Initialize tmux window name
if test -n "$TMUX"
    set -l mode (tmux show-option -gqv @window_name_mode)
    if test "$mode" != "command"
        tmux rename-window (basename $PWD)
    end
end

# Added by Antigravity CLI installer
if test -d $HOME/.local/bin
    fish_add_path $HOME/.local/bin
end
