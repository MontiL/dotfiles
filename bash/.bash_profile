
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# run only once to add ssh keys
# Start the ssh-agent in the background.
# eval "$(ssh-agent -s)"
# ssh-add "$HOME/.ssh/id_rsa"
# ssh-add "$HOME/.ssh/id_rsa_nutri"
# ssh-add "$HOME/.ssh/id_rsa_vege9"
