#!/usr/bin/env fish
# for x in (seq 4)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end
#
# for x in (seq 6 15)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end

set cmd "\" echo \"<PASSWORD>\" | sudo -S softwareupdate -i -a --restart \""

fish -c 'ssh codecat@codecat1.local  '$cmd &
fish -c 'ssh codecat@codecat2.local  '$cmd &
fish -c 'ssh codecat@codecat3.local  '$cmd &
fish -c 'ssh codecat@codecat4.local  '$cmd &
fish -c 'ssh codecat@codecat6.local  '$cmd &
fish -c 'ssh codecat@codecat7.local  '$cmd &
fish -c 'ssh codecat@codecat8.local  '$cmd &
fish -c 'ssh codecat@codecat9.local  '$cmd &
fish -c 'ssh codecat@codecat10.local '$cmd &
fish -c 'ssh codecat@codecat11.local '$cmd &
fish -c 'ssh codecat@codecat12.local '$cmd &
fish -c 'ssh codecat@codecat13.local '$cmd &
fish -c 'ssh codecat@codecat14.local '$cmd &
fish -c 'ssh codecat@codecat15.local '$cmd 

# sudo shutdown -h now

