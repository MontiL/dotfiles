# fish/.config/fish/config.fish

set -U fish_greeting # disable greeting message

set -gx EDITOR nvim
# set -gx TERM xterm-256color
set -gx TERM screen-256color # for tmux

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
set -g proj ~/.z/projects/capybara/

# aliases
# ------------------------------------------------------------
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
abbr -a -- - 'cd -'

alias cls clear
alias g git
alias gp "git pull"
alias gP "git push"
# alias gc 'git commit -v'
alias gc 'git checkout'
# alias gca 'git commit -v -a'
# alias gd 'git diff'
# alias gdc 'git diff --cached'
# alias gs 'git status'
# alias ga 'git add'
# alias gaa 'git add --all'
# alias gau 'git add --update'
# alias gb 'git branch'
# alias gba 'git branch -a'
# alias gbr 'git branch -r'
# alias gbd 'git branch -d'
# alias gbD 'git branch -D'
# alias gg "git pull && git push"
alias lg lazygit

alias gg "ghq get"
# command -qv nvim && alias vim nvim && alias v nvim
# command -qv nvim && alias vim nvim
# command -qv nvim && alias v nvim
# if type -q nvim
#     alias v nvim
# else if type -q vim
#     alias v vim
# else
#     alias v vi
# end
# alias vim nvim
alias v nvim

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
alias nit "pnpm install && pnpm devt"
alias np "pnpm dlx prisma migrate dev"

# alias nv neovide
# alias vim nvim
alias vimdiff "v -d"

alias t tmux # can follow by session name
alias ta "tmux attach"
alias tk "tmux kill-session -t" # can follow by session name
alias tl "tmux list-sessions"
alias tp "tmux new-session -s pyenv -e PYENV_INIT=1"
alias tw "tmux new-session -c ~/.z/projects/capybara/www.capybara.run/ \; new-window 'npx @agentdeskai/browser-tools-server'"

# if type -q exa
alias ls eza
alias la "ls -a"
alias ll "ls -l --icons"
alias lla "ll -a"
alias tree "eza --tree"
# alias tree "tree -C" # with color
# end
alias rg "rg -i."
alias free "free -m" # show sizes in MB
alias df "df -h" # human-readable sizes
alias x 'gxargs -d "\n"'
alias mkdir 'mkdir -p'

# Security
alias pc proxychains4
alias myip 'dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com'

# alias grep 'grep -P --color=always' 
# alias pdfgrep 'pfdgrep -P --color=always'  
# alias less 'less -R'       
# alias more 'more -R'       

alias ai 'open -a "Adobe Illustrator 2023"'
alias indd 'open -a "Adobe InDesign 2023"'
alias p 'open -a "Adobe Photoshop 2023"'
# alias tompb 'scp -r /Users/monti/Library/Preferences/Adobe\\ InDesign/Version\\ 17.0-J/zh_TW/Find-Change\\ Queries/GREP monti@mbp.local:/Users/monti/Library/Preferences/Adobe\\\\\ InDesign/Version\\\\\ 17.0-J/zh_TW/Find-Change\\\\\ Queries/'
# alias tom1 'scp -r /Users/monti/Library/Preferences/Adobe\\ InDesign/Version\\ 17.0-J/zh_TW/Find-Change\\ Queries/GREP monti@m1.local:/Users/monti/Library/Preferences/Adobe\\\\\ InDesign/Version\\\\\ 17.0-J/zh_TW/Find-Change\\\\\ Queries/'
# alias sc sc-im
# alias vs "visidata"

alias update "cd ~/.dotfiles/ && git submodule update --init && brew autoremove && brew bundle && brew update && brew upgrade"
alias clean "brew cleanup -s && rustup update && yarn cache clean"
alias clean_chrome "rm -rf /Users/"(whoami)"/Library/Caches/Google/Chrome/* && rm -rf /Users/"(whoami)"/Library/Application\ Support/Google/Chrome/Profile\ *"
#alias init_pyenv "pyenv init - | source && eval '$(pyenv virtualenv-init -)'"

alias block 'block_unblock block'
alias unblock 'block_unblock unblock'

# alias for projects
# set tmp_dir "date +%Y%m%d-%H%M"
# set san_dir "~/.z/projects/santec/"
# set cmd "\" mkdir "$san_dir"old/$tmp_dir \""
# set remote "monti@mbp.local"
# alias sa2m1local "fish -c 'ssh '$remote $cmd "
# #  && tar -cvf x.tar 2023 \
# #  && scp x.tar monti@"
# set remote "monti@m1.local"

# && npm update --localtion=global
# && pip3 install --upgrade pip \
# && pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U \
# && pip3 install -r pip_requirements \
# && cargo install-update -a"
# && cargo install --list | egrep '^[a-z0-9_-]+ .+:\$' | cut -f1 -d' ' | xargs cargo install"

alias himonti "ngrok tcp 22"
alias mchost "ngrok tcp 25565"

alias cafe "caffeinate -d"
alias done "terminal-notifier -message 'finished' -sound default; killall caffeinate"

# abbr fix "tsc | awk -F'(' '{print \$1}' | sort | uniq | xargs nvim -c 'autocmd CursorHold * lua vim.diagnostic.setqflist()'"
alias a amplify
# abbr a amplify
# abbr acg "amplify codegen" # *** ac override a system command
# abbr ac "amplify console" # *** ac override a system command
# abbr ap "amplify pull; say done"
# abbr aP "amplify push --y; say done"

alias y yazi

# PATH setting
# ------------------------------------------------------------
# set -gx PATH bin $PATH
# set -gx PATH ~/bin $PATH
# set -gx PATH ~/.local/bin $PATH
# set -gx PATH $HOME/.yarn/bin $PATH
# set -gx PATH ~/.cargo/bin $PATH
# # rbenv
# set -gx PATH ~/.rbenv/shims $PATH
# set -gx PATH ~/.gem $PATH
# # Go
# set -gx PATH /usr/local/go/bin $PATH
# set -gx PATH ~/go/bin $PATH

fish_add_path -gm ~/.local/bin # to be checked first
fish_add_path -g bin/
#
fish_add_path -g ~/.yarn/bin
#
fish_add_path -g ~/.cargo/bin
# rbnev
fish_add_path -g ~/.rbenv/shims
fish_add_path -g ~/.gem
# Go
fish_add_path -g /usr/local/go/bin
fish_add_path -g ~/go/bin
# pg_dump / pg_restore
fish_add_path /opt/homebrew/opt/libpq/bin
# node v20
fish_add_path /opt/homebrew/opt/node@20/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/node@20/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/node@20/include"
set -gx NODE_EXTRA_CA_CERTS "/private/etc/ssl/cert.pem"

# anaconda
# if test -d ~/../../opt/homebrew/anaconda3/bin
#   fish_add_path -g ~/../../opt/homebrew/anaconda3/bin
# end

# Java OpenJDK
# # If you need to have openjdk first in your PATH, run:
# fish_add_path /opt/homebrew/opt/openjdk/bin
# # For compilers to find openjdk you may need to set:
# set -gx CPPFLAGS -I/opt/homebrew/opt/openjdk/include
# set -x JAVA_HOME (/usr/libexec/java_home -v 16)

# Brew config
# ------------------------------------------------------------
# set -l pref (brew --prefix)
# set -gx BREW_PREFIX (brew --prefix)

# source ~/.dotfiles/fish/.config/fish/config-yushun.fish

switch (uname)
    case Darwin
        # eval "$(/opt/homebrew/bin/brew shellenv)"
        # eval ($BREW_PREFIX/bin/brew shellenv)
        # eval "$pref/bin/brew shellenv"

        # config for Mac
        # set -gx fish_user_paths $BREW_PREFIX/bin $fish_user_paths # Add brew binaries in fish path:
        # source (dirname (status --current-filename))/config-osx.fish
        source ~/.dotfiles/fish/.config/fish/config-osx.fish
    case Linux
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        # config for Linux
        # source (dirname (status --current-filename))/config-linux.fish
        source ~/.dotfiles/fish/.config/fish/config-linux.fish
        # case '*'
        # config for Windows
        # source (dirname (status --current-filename))/config-windows.fish
        # source ~/.dotfiles/fish/.config/fish/config.fish
end

# set -gx XDG_DATA_HOME ~/.local/share $XDG_DATA_HOME

# Colorful man pages
# ------------------------------------------------------------
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\033[01;32m")


# # chruby
# source (dirname (status --current-filename))/chruby.fish
# source (dirname (status --current-filename))/auto.fish

# zoxide
zoxide init fish | source

# Starship
starship init fish | source

# vi mode for fish
# fish_vi_key_bindings

# Bat
#   show available themes:
#   bat --list-themes | fzf --preview="bat --theme={} --color=always /path/to/file"
set -x BAT_THEME DarkNeon

# Fzf
fzf_configure_bindings --directory=\cs --history=\cr --process=\cx --git_log=\cg # --git_status=\cs
set fzf_fd_opts --hidden --exclude=.git #--bind=ctrl-/:toggle-preview fzf --preview='cat {}'
set fzf_preview_file_cmd "fzf --preview 'cat {}' --preview-window right:90%:hidden:wrap --bind ctrl-/:toggle-preview"
# set fzf_fd_opts "--preview-window right:60%:hidden:wrap --bind ctrl-/:toggle-preview fzf --preview 'cat {}'"
# set fzf_preview_file_cmd bat
# CTRL-/ to show preview window which is hidden by default
# set FZF_DEFAULT_OPTS "--preview-window right:60%:hidden:wrap --bind ctrl-/:toggle-preview fzf --preview 'bat {}'"

# Fzf widget (deprecated?)
# set -g FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git --exclude node_modules'
# set -g FZF_ALT_C_COMMAND $FZF_DEFAULT_COMMAND # used by Ctrl-f
# set -g FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND # used by Ctrl-s


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -d /opt/homebrew/anaconda3/bin/conda 
#   eval /opt/homebrew/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# end
# <<< conda initialize <<<

# pnpm
set -gx PNPM_HOME "/opt/homebrew/bin"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Added by Windsurf
fish_add_path /Users/monti/.codeium/windsurf/bin

# Ollama
set -gx OLLAMA_HOST "0.0.0.0"

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/monti/.cache/lm-studio/bin
