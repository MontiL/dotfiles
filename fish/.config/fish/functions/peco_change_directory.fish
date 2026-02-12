function _peco_change_directory
    if [ (count $argv) ]
        # peco --layout=bottom-up --query "$argv "|perl -pe 's/([ ()])/\\\\$1/g'|read foo
        peco --layout=bottom-up --query "$argv" | read foo
    else
        # peco --layout=bottom-up |perl -pe 's/([ ()])/\\\\$1/g'|read foo
        peco --layout=bottom-up | read foo
    end
    if [ $foo ]
        builtin cd $foo
        commandline -r ''
        commandline -f repaint
    else
        commandline ''
    end
end

function peco_change_directory
    begin
        # Capybara worktrees
        set -l capy $HOME/.z/projects/capybara
        echo $capy/www.capybara.run
        for n in 1 2 3 4 5
            echo $capy/agent$n
        end
        if test -d $capy/workers
            for pd in $capy/workers/*/
                for wd in $pd/w*/
                    test -d "$wd"; and echo $wd
                end
            end
        end

        echo $HOME/.dotfiles
        # echo $HOME/.config

        # switch (uname)
        # case Darwin
        # if test -d $HOME/.z/projects
        # echo $HOME/z/projects
        # ls -ad $HOME/z/projects/* | grep -v \.git
        # fd . $HOME/.z/projects -td -d1 -cnever
        # find -s $HOME/.z/projects -type d -maxdepth 1 \( ! -iname ".DS_Store" \)
        # end

        # if test -d $HOME/.z/examples
        # echo $HOME/z/examples/
        # ls -ad $HOME/z/examples/*/* | grep -v \.git
        # fd . $HOME/.z/examples -td -d1 -cnever
        # find -s $HOME/.z/examples -type d -maxdepth 2 \( ! -iname ".DS_Store" -iname ".git" \)
        # fd . $HOME/.z/examples/ -d1
        # end

        # if test -d $HOME/.z/test
        # echo $HOME/.z/test
        # fd . $HOME/.z/test -td -d1 -cnever
        # find -s $HOME/.z/test -type d -maxdepth 1 \( ! -iname ".DS_Store" \)
        # end

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
            else
                : # echo 'Something wrong with google Drive ?'
                # return 1
            end

            fd . $DHOME -d3 -td --hidden --follow
            # if test -d $DHOME/.coding
            #     fd . $DHOME/ -d3 -td --follow
            # fd . $DHOME/
            # fd . $DHOME/.coding/ -d2 -td | grep -v "Students_*"
            # ls -ad $DHOME/.coding/Students_Python/*/ | grep -v ok
            # ls -ad $DHOME/.coding/Books/*/
            # ls -ad $DHOME/.coding/Certification/
            # ls -ad $DHOME/.coding/Examples/*/
            # ls -ad $DHOME/.coding/codecat/*/
            # end
            # if test -d $DHOME/.project
            #     ls -ad $DHOME/.project/*/
            # end
            # find $HOME/Google\ Drive/我的雲端硬碟/students -maxdepth 2 | grep -v ok
        else
            : # echo '忘記開Google Drive了'
            # return 1
        end
        # end


        # Adobe
        if test -d $HOME/Library/Preferences/Adobe\ InDesign
            # preferences
            # echo '/Users/monti/Library/Preferences/Adobe InDesign/Version 17.0-J/zh_TW/Find-Change Queries/GREP/'
            ls -ad $HOME/Library/Preferences/Adobe\ InDesign
        end
        if test -d $HOME/Library/Preferences/Adobe\ Illustrator\ 26\ Settings
            ls -ad $HOME/Library/Preferences/Adobe\ Illustrator\ 26\ Settings
        end

        # external drive
        ls -ad /Volumes/*
        set r6 /Volumes/Pegasus2R6
        if test -d $r6
            fd . $r6/Projects -d2 -td
        end

        # current folders
        # ls -ad */ | perl -pe "s#^#$PWD/#" | grep -v \.git
    end | sed -e 's/\/\//\//;s/\/$//' | _peco_change_directory $argv
    # end | sed -e 's/\/$//' | awk '!a[$0]++' | _peco_change_directory $argv
end
