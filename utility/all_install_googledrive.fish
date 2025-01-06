#!/usr/bin/env fish
# for x in (seq 4)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end
#
# for x in (seq 6 15)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end

fish -c 'ssh user@codecat1.local      "brew install --cask google-drive"' &
fish -c 'ssh user@codecat2.local      "brew install --cask google-drive"' &
fish -c 'ssh user@codecat3.local      "brew install --cask google-drive"' &
fish -c 'ssh user@codecat4.local      "brew install --cask google-drive"' &
fish -c 'ssh user@codecat6.local      "brew install --cask google-drive"' &
fish -c 'ssh user@codecat7.local      "brew install --cask google-drive"' &
fish -c 'ssh user@codecat8.local      "brew install --cask google-drive"' &
fish -c 'ssh user@codecat9.local      "brew install --cask google-drive"' &
fish -c 'ssh user@codecat10.local     "brew install --cask google-drive"' &
fish -c 'ssh user@codecat11.local     "brew install --cask google-drive"' &
fish -c 'ssh user@codecat12.local     "brew install --cask google-drive"' &
fish -c 'ssh user@codecat13.local     "brew install --cask google-drive"' &
fish -c 'ssh user@codecat15.local     "brew install --cask google-drive"' &

# fish -c 'ssh codecat@codecat5.local  "brew install --cask google-drive"' &
# fish -c 'ssh user@codecat14.local     "brew install --cask google-drive"' &

