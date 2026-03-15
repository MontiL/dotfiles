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
    bind \cp fzf_change_directory # Ctrl+P: change directory
    # bind \co ok_python_exercise # ok Python exercise
    bind \co 'ql; commandline -f repaint' # Ctrl+O: Queue List (Out)
    bind \cq _qadd_smart_binding # Ctrl+Q: Queue Add (Smart)

    # change default key binding
    bind --preset $argv \cf forward-word
    bind --preset $argv \cb backward-word
    bind --preset $argv \ep up-or-search
    bind --preset $argv \en down-or-search

    # Insert last argument of previous command
    bind ! bind_bang
    bind '$' bind_dollar
end
