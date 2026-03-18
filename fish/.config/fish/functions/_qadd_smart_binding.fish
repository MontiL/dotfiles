function _qadd_from_editor
    # Create a temp file
    set -l tmpfile (mktemp)
    
    # Open editor
    if set -q EDITOR
        $EDITOR +startinsert $tmpfile
    else
        vim $tmpfile
    end

    # If file is not empty, add content to queue
    if test -s $tmpfile
        # Read file content and pass to qadd
        # We read into a variable to handle newlines correctly
        set -l content (cat $tmpfile)
        qadd $content
    else
        echo "Empty prompt, cancelled."
    end

    # Cleanup
    rm $tmpfile
    commandline -f repaint
end

function _qadd_smart_binding
    set -l cmd (commandline)
    if test -z "$cmd"
        # If command line is empty, open editor
        _qadd_from_editor
    else
        # If there is text, add it to queue directly
        qadd $cmd
        commandline ""
        commandline -f repaint
    end
end
