#!/usr/bin/env fish

rsync -avzh --delete ~/.dotfiles/ user@codecat1.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat2.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat3.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat4.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat6.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat7.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat8.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat9.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat10.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat11.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat12.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat13.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat14.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ codecat@codecat14.local:~/.dotfiles/
rsync -avzh --delete ~/.dotfiles/ user@codecat15.local:~/.dotfiles/

set cmd "\" cd ~/.dotfiles && brew autoremove && brew bundle && brew update && brew upgrade \""

fish -c 'ssh user@codecat1.local  '$cmd &
fish -c 'ssh user@codecat2.local  '$cmd &
fish -c 'ssh user@codecat3.local  '$cmd &
fish -c 'ssh user@codecat4.local  '$cmd &

# fish -c 'ssh user@codecat5.local  '$cmd &

fish -c 'ssh user@codecat6.local  '$cmd &
fish -c 'ssh user@codecat7.local  '$cmd &
fish -c 'ssh user@codecat8.local  '$cmd &
fish -c 'ssh user@codecat9.local  '$cmd &
fish -c 'ssh user@codecat10.local '$cmd &
fish -c 'ssh user@codecat11.local '$cmd &
fish -c 'ssh user@codecat12.local '$cmd &
fish -c 'ssh user@codecat13.local '$cmd &

# fish -c 'ssh user@codecat14.local '$cmd &

fish -c 'ssh codecat@codecat14.local '$cmd &
fish -c 'ssh user@codecat15.local '$cmd
