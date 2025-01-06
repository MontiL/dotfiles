#!/usr/bin/env fish
# for x in (seq 4)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end
#
# for x in (seq 6 15)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end

fish -c 'ssh codecat@codecat1.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat2.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat3.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat4.local "sudo shutdown -r now"' &

fish -c 'ssh codecat@codecat6.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat7.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat8.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat9.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat10.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat11.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat12.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat13.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat14.local "sudo shutdown -r now"' &
fish -c 'ssh codecat@codecat15.local "sudo shutdown -r now"' &

# sudo shutdown -h now

