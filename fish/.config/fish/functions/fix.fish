function fix
    # Capture the output of the tsc command into a variable
    # set output (tsc | awk -F':' '/src\// {gsub(/\([0-9]+,[0-9]+\)/, "", $1); print $1}' | uniq)
    set output (tsc | awk -F':' '/src\\// && !/.next\\// {sub(/\([0-9]+,[0-9]+\)/, "", $1); print $1}' | uniq)

    # Check if the output variable is empty
    if test -z "$output"
        echo "No errors found by tsc."
    else
        # If there are errors, open the files in nvim
        echo $output | xargs nvim -c 'autocmd CursorHold * lua vim.diagnostic.setqflist()'
    end
end
