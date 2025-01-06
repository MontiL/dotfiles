function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t -- $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -f backward-delete-char history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function fish_user_key_bindings
    bind \ch peco_select_history # Bind for peco select history to Ctrl+R
    bind \cp peco_change_directory # Bind for peco change directory to Ctrl+F
    bind \co ok_python_exercise # ok Python exercise
    # bind \cx peco_kill_process # kill process
    # bind \cg ranger

    # bind \cq paper # Mia paper

    # change default key binding
    bind --preset $argv \cf forward-word
    bind --preset $argv \cb backward-word
    bind --preset $argv \ep up-or-search
    bind --preset $argv \en down-or-search

    # vim-like
    #bind \cl forward-char # use Karabiner-elements to map arrow keys
    # prevent iterm2 from closing when typing Ctrl-D (EOF)
    #  bind \cd delete-char

    # Insert last argument of previous command
    # bind -M insert \e. history-token-search-backward
    # bind \cu history-token-search-backward
    bind ! bind_bang
    bind '$' bind_dollar
end

# (deprecated ?)
# fzf_key_bindings

# bind \cs fzf-file-widget
# bind \cr fzf-history-widget
# bind \cf fzf-cd-widget
#
# if bind -M insert > /dev/null 2>&1
#   bind -M insert \cs fzf-file-widget
#   bind -M insert \cr fzf-history-widget
#   bind -M insert \cf fzf-cd-widget
# end
