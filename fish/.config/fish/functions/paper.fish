set TEX_HOME "$HOME/Google Drive/我的雲端硬碟/miatex"

function paper
  set selections (
    begin
      if test -d $TEX_HOME
        ls -ad $TEX_HOME
        fd . -e tex -e pdf $TEX_HOME
      end
    end | _fzf_wrapper --multi \
                       # --header-lines=1 \
                       # --preview="fd . -e tex -e pdf '$TEX_HOME' {}"
                       # --preview="fd . -e tex -e pdf ~/.dotfiles/ {}"
                       --preview="bat --style=numbers --color=always --line-range :500 {}"
  )

  if test $status -eq 0
      for selection in $selections
        if string match -r '.*\.pdf$' $selection --quiet
          set --append pdf_list (string replace ' ' '\\ ' $selection) 
        else if string match -r '.*\.tex$' $selection --quiet
          set --append tex_list (string replace ' ' '\\ ' $selection) 
        else
          cd $TEX_HOME
          commandline -f repaint
        end
      end
      # string join to replace the newlines outputted by string split with spaces
      commandline --current-token --replace -- (string join ' ' 'open' $pdf_list '&&' 'v' $tex_list)
  end
end
