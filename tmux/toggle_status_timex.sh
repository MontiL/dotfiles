#!/bin/bash

current_status_right=$(tmux show-option -gqv status-right)

if [[ $current_status_right == *"%h %d (%a) %l:%M %p"* ]]; then
  tmux set -g status-right "#[default]#[fg=black,bg=white] #(echo $USER) @ #H "
else
  tmux set -g status-right "#[default]#[fg=white] %h %d (%a) %l:%M %p #[default]#[fg=black,bg=white] #(echo $USER) @ #H "
fi

echo "Reloaded!"

