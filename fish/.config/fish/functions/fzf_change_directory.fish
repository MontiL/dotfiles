function fzf_change_directory
    begin
        # Capybara worktrees
        set -l capy $HOME/.z/projects/capybara
        test -d $capy/www; and echo $capy/www
        for n in 1 2 3 4 5
            test -d $capy/agent$n; and echo $capy/agent$n
        end
        if test -d $capy/workers
            for pd in $capy/workers/*/
                for wd in $pd/w*/
                    test -d "$wd"; and echo $wd
                end
            end
        end

        echo $HOME/.dotfiles

        # .z
        if test -d $HOME/.z
            fd . $HOME/.z -d2 -td | grep -v /ghq
            ghq list -p
        end

        # Google Drive
        if test -d $HOME/Google\ Drive
            if test -d $HOME/Google\ Drive/我的雲端硬碟
                set DHOME $HOME/Google\ Drive/我的雲端硬碟
            else if test -d $HOME/Google\ Drive/My\ Drive
                set DHOME $HOME/Google\ Drive/My\ Drive
            end

            if set -q DHOME
                fd . $DHOME -d3 -td --hidden --follow
            end
        end

        # Adobe
        if test -d $HOME/Library/Preferences/Adobe\ InDesign
            ls -ad $HOME/Library/Preferences/Adobe\ InDesign
        end
        if test -d $HOME/Library/Preferences/Adobe\ Illustrator\ 26\ Settings
            ls -ad $HOME/Library/Preferences/Adobe\ Illustrator\ 26\ Settings
        end

        # external drive (macOS only)
        if test -d /Volumes
            ls -ad /Volumes/*
            set -l r6 /Volumes/Pegasus2R6
            if test -d $r6
                fd . $r6/Projects -d2 -td
            end
        end
    end | sed -e 's/\/\//\//;s/\/$//' | fzf --height=~50% --reverse --scheme=path | read -l selected

    if test -n "$selected"
        builtin cd "$selected"
        commandline -r ''
        commandline -f repaint
    else
        commandline ''
    end
end
