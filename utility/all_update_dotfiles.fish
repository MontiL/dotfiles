#!/usr/bin/env fish

for x in (seq 1 6)
    if test $x -ne 5
        rsync -avzh --delete ~/.dotfiles/ user@codecat$x.local:~/.dotfiles/
    end
end

#
# for x in (seq 6 15)
#   fish -c `ssh codecat@codecat$x.local "sudo shutdown -h now"` &
# end



# fish -c 'ssh codecat@codecat14.local "brew install "'$cmd 
# fish -c 'ssh user@codecat5.local     "brew install "'$cmd &
# fish -c 'ssh codecat@codecat5.local  "cd ~/.dotfiles/ && g pl"' &
# sudo shutdown -h now
