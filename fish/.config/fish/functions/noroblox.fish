function noroblox
    ssh $argv "diskutil unmount /Volumes/Roblox/"
    ssh $argv "rm -rf ~/Applications/Roblox.app/; rm -rf /Applications/Roblox.app/; rm ~/Downloads/Roblox*; rm -rf ~/Desktop/Roblox.app/"
end
