function run
    if test -d node_modules
        npm run dev
    else
        npm install && npm run dev
    end
end

function of
    open .
end

function oc
    code .
end


function cl
    cd $argv # arguments
    ls
end

function ca
    cd $argv
    lla
end
