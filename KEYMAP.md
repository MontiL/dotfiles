# Keymap for nvim, tmux, yabai

## Switch focus (s, \ct, alt)

nvim: s + hjkl
tmux: \ct + hjkl
yabai: alt + hjkl

## Split panel/window (-\)

nvim: s + -\
tmux: \ct + -\
yabai: n/a

## Resize panel/window (Ctrl+hjkl)

nvim: \c + hjkl, \_|= (balance)
tmux: \ct \c + hjkl, \ct + z (zoom)
yabai: alt \c + hjkl, alt + f (focus)

## Move panel/window (s+arrow key, TODO, alt+arrow)

nvim: s + ⬆️ ➡️ ⬇️:⬅️:
tmux: \c shift ⬅️:➡️ (move window sequence), TODO (move panel sequence) `\ct + }{ is swap with next/previous pane`
yabai: alt + ⬆️ ➡️ ⬇️:⬅️: (swap), alt shift + ⬆️ ➡️ ⬇️:⬅️: (move)
