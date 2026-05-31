function _fzf_search_directory_all --description 'Like _fzf_search_directory (ctrl-s) but also shows .gitignore-d files (photos, build artifacts, etc.)'
    # Temporarily widen fzf_fd_opts with --no-ignore-vcs so fd stops honoring
    # .gitignore / .git/info/exclude / global gitignore. _fzf_search_directory
    # reads the *global* fzf_fd_opts, so save & restore around the call.
    set -f saved $fzf_fd_opts
    set -g fzf_fd_opts $fzf_fd_opts --no-ignore-vcs
    _fzf_search_directory
    set -g fzf_fd_opts $saved
end
