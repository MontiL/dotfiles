## config for Wake for Network Access
## pmset -g
## sudo pmset -a womp 1
# set mac_addresses aaron_mac abbie_mac dino_mac terry_mac 8c:85:90:47:82:7f mia_mac

set users aaron abbie mia qoo dino terry monti

function _block_unblock -a user command
    echo $command $user@$user.local ...
    if ping -c 1 -W 1 $user.local >/dev/null
        ssh -o ConnectTimeout=10 $user@$user.local "echo \"12344321\" | sudo -S ln -f ~/.dotfiles/hosts/$command/hosts /etc/hosts && dscacheutil -flushcache"
        if test $command = block
            echo 🛑 $user
        else if test $command = unblock
            echo ✅ $user
        end
    else
        echo $user.local is down, skipping...
    end
end


function block_unblock -a command
    if string match -q all $argv[1]
        for user in $users
            _block_unblock $user $command
        end
    else
        for arg in $argv
            if contains $arg $users
                _block_unblock $arg $command
            end
        end
    end

    if string match -q me $argv
        sudo -S ln -f ~/.dotfiles/hosts/$command/hosts /etc/hosts && dscacheutil -flushcache
    end
end
