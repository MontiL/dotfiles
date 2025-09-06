function _peco_kill_process
  if [ (count $argv) ]
    peco --layout=bottom-up --query "$argv" |read foo
  else
    peco --layout=bottom-up |read foo
  end

  if [ $foo ]
    echo -e $foo | sed -e 's/^\s\+//' | cut -f 2 -w | read command
    # echo 'kill' $command | read newcommand
    # commandline $newcommand
    # echo 'kill' $command
    kill $command
    # ps | peco | cut -f 1 -d ' ' | xargs -n1 echo
    commandline -r ''
    commandline -f repaint
  else
    commandline ''
  end
end

function peco_kill_process
  begin
    ps aux
  end | _peco_kill_process $argv
end
