#!/usr/bin/env fish

# KeyRepeat: 120, 90, 60, 30, 12, 6, 2
# InitialKeyRepeat: 120, 94, 68, 35, 25, 15
set cmd "\" defaults write NSGlobalDomain KeyRepeat -int 2 \"" 
fish -c (string join ' ' 'ssh' $argv $cmd)
set cmd "\" defaults write NSGlobalDomain InitialKeyRepeat -int 15 \"" 
fish -c (string join ' ' 'ssh' $argv $cmd)

