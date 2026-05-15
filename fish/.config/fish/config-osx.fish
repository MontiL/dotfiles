# if which pyenv > /dev/null; eval "$(pyenv init -)"; end
# if which pyenv-virtualenv-init > /dev/null; eval "$(pyenv virtualenv-init -)"; end
# status is-login; and pyenv init --path | source
# status is-interactive; and pyenv init - | source
# status --is-interactive; and . (pyenv virtualenv-init -|psub)

switch (uname -m)
    case arm64
        eval (/opt/homebrew/bin/brew shellenv)
        # set -gx fish_user_paths /opt/homebrew/bin $fish_user_paths # Add brew binaries in fish path:

        # # python@3.10
        # # If you need to have python@3.10 first in your PATH, run:
        # fish_add_path /opt/homebrew/opt/python@3.10/bin
        # # For compilers to find python@3.10 you may need to set:
        # set -gx LDFLAGS "-L/opt/homebrew/opt/python@3.10/lib"
        # # For pkg-config to find python@3.10 you may need to set:
        # set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/python@3.10/lib/pkgconfig"
        #
        # alias python /opt/homebrew/opt/python@3.10/bin/python3

        # If you need to have bison first in your PATH, run:
        fish_add_path /opt/homebrew/opt/bison/bin
        # For compilers to find bison you may need to set:
        set -gx LDFLAGS -L/opt/homebrew/opt/bison/lib

        # GNU grep
        fish_add_path -g /opt/homebrew/opt/grep/libexec/gnubin

        # python
        fish_add_path -g /opt/homebrew/opt/python@3.12/libexec/bin

        # LLVM
        fish_add_path /opt/homebrew/opt/llvm/bin
        alias g++=/opt/homebrew/opt/llvm/bin/clang++
        alias gcc=/opt/homebrew/opt/llvm/bin/clang

    case x86_64
        eval (/usr/local/bin/brew shellenv)
        # set -gx fish_user_paths /usr/local/bin $fish_user_paths # Add brew binaries in fish path:

        # # python@3.10
        # # If you need to have python@3.10 first in your PATH, run:
        # fish_add_path /usr/local/opt/python@3.10/bin
        # # For compilers to find python@3.10 you may need to set:
        # set -gx LDFLAGS "-L/usr/local/opt/python@3.10/lib"
        # # For pkg-config to find python@3.10 you may need to set:
        # set -gx PKG_CONFIG_PATH "/usr/local/opt/python@3.10/lib/pkgconfig"
        #
        # alias python /usr/local/opt/python@3.10/bin/python3

        # If you need to have bison first in your PATH, run:
        fish_add_path /usr/local/opt/bison/bin
        # For compilers to find bison you may need to set:
        set -gx LDFLAGS -L/usr/local/opt/bison/lib

        # GNU grep
        fish_add_path -g /usr/local/opt/grep/libexec/gnubin
        # python
        fish_add_path -g /usr/local/opt/python@3.12/libexec/bin
end

# pyenv init - | source
# eval "$(pyenv virtualenv-init -)"
if set -q PYENV_INIT
    pyenv init - | source
end

# fnm (Node.js version manager)
if command -v fnm &> /dev/null
    fnm env --use-on-cd --shell fish | source
end

# # have ruby first in your PATH, run:
# set -gx fish_add_path `(brew --prefix)/opt/homebrew/opt/ruby/bin`
# # For compilers to find ruby you may need to set:
# set -gx LDFLAGS `-L(brew --prefix)/opt/ruby/lib`
# set -gx CPPFLAGS `-I(brew --prefix)/opt/ruby/include`
#
# # For pkg-config to find ruby you may need to set:
# set -gx PKG_CONFIG_PATH "(brew --prefix)/opt/ruby/lib/pkgconfig"

# Add the following to the ~/.bash_profile or ~/.zshrc file:
# source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
# To enable auto-switching of Rubies specified by .ruby-version files,
# add the following to ~/.bash_profile or ~/.zshrc:
# source /opt/homebrew/opt/chruby/share/chruby/auto.sh
