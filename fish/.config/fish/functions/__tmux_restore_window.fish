function __tmux_restore_window --on-event fish_postexec
    if test -n "$TMUX"
        tmux rename-window "fish"
    end
end