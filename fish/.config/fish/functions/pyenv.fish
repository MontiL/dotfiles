# fish/.config/fish/functions/pyenv.fish

function pe
    if test -f Pipfile
        pipenv shell
    else
        echo "No Pipfile found in the current directory."
    end
end

function pr
    if test -f Pipfile
        pipenv run python $argv
    else
        echo "No Pipfile found. Running with system Python."
        eval $argv
    end
end

function pi
    pipenv install $argv
end

function pu
    pipenv uninstall $argv
end
