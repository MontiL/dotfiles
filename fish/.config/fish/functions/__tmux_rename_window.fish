function __tmux_rename_window --on-event fish_preexec
    if test -n "$TMUX"
        set -l cmd (string split " " $argv[1])[1]
        if test $cmd = "claude"
            tmux rename-window "claude"
        else if test $cmd = "pnpm"
            tmux rename-window "pnpm"
        else if test $cmd = "npm"
            tmux rename-window "npm"
        else
            tmux rename-window $cmd
        end
    end
end