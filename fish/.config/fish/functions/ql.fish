function ql --description "List, select, copy and remove prompt from queue (directory-based)"
    set -q PROMPT_QUEUE_DIR; or set -U PROMPT_QUEUE_DIR "$HOME/.prompt_queue"

    if not test -d "$PROMPT_QUEUE_DIR"; or test (count (ls "$PROMPT_QUEUE_DIR")) -eq 0
        echo "Queue is empty."
        return
    end

    # Generate list for fzf
    # Format: filename [TAB] first_line_preview
    set -l fzf_input
    for f in "$PROMPT_QUEUE_DIR"/*.txt
        # Read the file content, trim leading/trailing newlines and spaces, then take the first line
        # 'string trim' handles whitespace, then we pick the first non-empty line
        set -l clean_content (cat "$f" | string trim)
        set -l first_line (echo "$clean_content" | head -n 1 | string sub -l 60 | string replace -a "\t" " ")
        
        if test -z "$first_line"
            set first_line "(Empty)"
        end
        # Store as distinct elements in the list
        set -a fzf_input "$f" "$first_line"
    end

    # Run fzf in fullscreen
    # We use printf to format the output with actual tabs for fzf
    set -l selection (printf "%s\t%s\n" $fzf_input | fzf -d "\t" --with-nth 2.. --preview "cat {1}" --header "Enter: Copy & Delete | Esc: Cancel" --reverse)

    if test -n "$selection"
        # Extract filename (field 1)
        set -l filename (echo "$selection" | awk -F'\t' '{print $1}')
        
        if test -f "$filename"
            # Copy content to clipboard directly from file
            # This preserves exact formatting, newlines, tabs, etc.
            cat "$filename" | pbcopy
            
            echo "📋 Copied to clipboard:"
            set_color green
            cat "$filename"
            set_color normal
            
            # Remove file
            rm "$filename"
            echo "🗑️  Removed from queue."
            echo "Pending: "(count (ls "$PROMPT_QUEUE_DIR"))
        else
            echo "Error: File not found: $filename"
        end
    end
end
