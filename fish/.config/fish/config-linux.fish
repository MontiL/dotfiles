# fish/.config/fish/config-linux.fish
# Linux-specific configuration

# ~/.local/bin (zoxide, bat symlink, etc.)
fish_add_path -g ~/.local/bin
fish_add_path /usr/local/go/bin

# fnm (Node.js version manager)
if [ -d "$HOME/.local/share/fnm" ]
    fish_add_path "$HOME/.local/share/fnm"
    fnm env --use-on-cd --shell fish | source
end

alias fd='fdfind'
