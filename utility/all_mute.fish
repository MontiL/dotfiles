#!/usr/bin/env fish
# for x in (seq 4)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end
#
# for x in (seq 6 15)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end

# set sw "visual-studio-code"
# set cmd "\" brew services start skhd \""
# set cmd "\" skhd -k 'cmd - w' \"" # quit tab of chrome
# set cmd "\" skhd -k 'cmd + ctrl - q' \"" # lock screen
# set cmd "\" sudo shutdown -h now \"" # shutdown
# set cmd "\" brew uninstall keycastr \"" # shutdown
# set cmd "\" cd ~/.dotfiles && git pull \"" # shutdown
set cmd '" osascript -e \"set Volume 0\" "'

fish -c 'ssh user@codecat1.local  '$cmd &
fish -c 'ssh user@codecat2.local  '$cmd &
fish -c 'ssh user@codecat3.local  '$cmd &
fish -c 'ssh user@codecat4.local  '$cmd &
fish -c 'ssh user@codecat6.local  '$cmd &
fish -c 'ssh user@codecat7.local  '$cmd &
fish -c 'ssh user@codecat8.local  '$cmd &
fish -c 'ssh user@codecat9.local  '$cmd &
fish -c 'ssh user@codecat10.local '$cmd &
fish -c 'ssh user@codecat11.local '$cmd &
fish -c 'ssh user@codecat12.local '$cmd &
fish -c 'ssh user@codecat13.local '$cmd &
fish -c 'ssh codecat@codecat14.local '$cmd &
fish -c 'ssh user@codecat15.local '$cmd 

# fish -c 'ssh codecat@codecat14.local "brew install "'$cmd 
# fish -c 'ssh user@codecat5.local     "brew install "'$cmd &
# fish -c 'ssh codecat@codecat5.local  "cd ~/.dotfiles/ && g pl"' &
# sudo shutdown -h now

