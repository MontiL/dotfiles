function ok_python_exercise
    # if test (count $argv) = 0
    #   set peco_flags --layout=bottom-up
    # else
    #   set peco_flags --layout=bottom-up --query "$argv"
    # end


    # set files into array:
    # set -l foo test1.py test2.py

    # enable multi-mode in fzf: ls | fzf --multi
    # Then use Tab or ShiftTab to mark multiple items.

    # find (pwd) -type f |peco $peco_flags |read foo


    # find -L (pwd)/ -not -path '*/\.*' -not -path '*ok/*' -not -path '*範例實作*' -not -path '*/__pycache__/*' -not -name '*ok*' -not -name '*test*' -not -path '*test*' -not -name '*.gdoc' -not name '*.txt' -not -name '*.jpg' -not -name '*.JPG' -type f \
    #   | sort \
    #   | perl -pe 's/\/\//\//g' \
    fd 'choice|選擇題|.*\.py' -E "*ok*" \
        | fzf --height 17% --multi \
        | read foo

    # TODO: multi-select
    # find (pwd) -type f |fzf --multi --height 17% |xargs -d\n |set -l foo

    if [ $foo ]
        # echo $foo | sed -e 's/.py/ (ok).py/' |read new_name
        # mv -v  -- "$foo" "$new_name"

        # # make fullpath
        # # echo $foo |perl -pe 's/([ ()])/\\\\$1/g' | read fullpath
        # echo $foo | read fullpath
        # # change folder
        # cd (dirname $fullpath)
        # # make new command
        # basename $fullpath | perl -pe 's/([ ()<>])/\\\\$1/g' | perl -pe 's/(^)/v -d $1/g' | read newcommand

        # keep relative path
        echo $foo | perl -pe 's/([ ()<>])/\\\\$1/g' | perl -pe 's/(^)/v -d $1/g' | read newcommand

        commandline $newcommand
        # commandline -r ''
        # commandline -f repaint
    else
        commandline ''
    end
end
