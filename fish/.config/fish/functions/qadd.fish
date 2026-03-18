function qadd --description "Add a prompt to the queue (directory-based)"
    set -q PROMPT_QUEUE_DIR; or set -U PROMPT_QUEUE_DIR "$HOME/.prompt_queue"

    # If no arguments provided, open editor for multi-line input
    if test (count $argv) -eq 0
        set -l tmpfile (mktemp)
        
        # Open editor (use EDITOR env var or fallback to vim)
        if set -q EDITOR
            $EDITOR $tmpfile
        else
            vim $tmpfile
        end

        # If file is not empty, read content
        if test -s $tmpfile
            set argv (cat $tmpfile)
        else
            echo "Empty prompt, cancelled."
            rm $tmpfile
            return 1
        end
        rm $tmpfile
    end

    # Ensure directory exists
    if not test -d "$PROMPT_QUEUE_DIR"
        mkdir -p "$PROMPT_QUEUE_DIR"
    end

    # Migrate old queue file if it exists
    set -l old_queue_file "$HOME/.prompt_queue.md"
    if test -f "$old_queue_file"
        echo "📦 Migrating old queue file..."
        set -l timestamp (date +%s%N)
        mv "$old_queue_file" "$PROMPT_QUEUE_DIR/restored_$timestamp.txt"
        echo "✅ Old queue migrated to restored_$timestamp.txt"
    end

    # Generate unique filename using nanosecond timestamp
    set -l timestamp (date +%s%N)
    set -l filename "$PROMPT_QUEUE_DIR/$timestamp.txt"

    # Write content to file (handles newlines natively)
    string join \n $argv > "$filename"
    
    echo "✅ Added to queue."
    echo "Pending: "(count (ls "$PROMPT_QUEUE_DIR"))
end
