#!/usr/bin/env fish
# KeyRepeat: 120, 90, 60, 30, 12, 6, 2
# InitialKeyRepeat: 120, 94, 68, 35, 25, 15

# for i in (seq 1 15)
  # fish -c 'ssh user@codecat'$i'.local \"defaults write NSGlobalDomain KeyRepeat -int 2\"'
  # fish -c 'ssh user@codecat'$i'.local \"defaults write NSGlobalDomain InitialKeyRepeat -int 15\"'
# end
fish -c 'ssh user@codecat1.local \"defaults write NSGlobalDomain KeyRepeat -int 2\"'
