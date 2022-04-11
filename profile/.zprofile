# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -n "$BASH_VERSION" ]; then
   exit 1
fi

# Do OS specific things
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    # Emacsclient and disown
    function ec() { emacsclient "$@" &! }

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    alias emacs='open -a /Applications/Emacs.app $1'
    alias ec='open -a /Applications/Emacs.app $1'

    # Compile
    # alias gccc='/usr/local/bin/gcc-6 -std=c++11 -Werror -Wall -Wextra'
    # alias g+++='/usr/local/bin/g++-6 -std=c++11 -Werror -Wall -Wextra'

    # Homebrew
    alias brewup='brew update; brew upgrade; brew cleanup; brew doctor'
else
    echo "OS type unknown, shell setup could be bad"
fi

# More colors
export TERM="xterm-256color"

# Sudo emacs
alias sudoec="SUDO_EDITOR=\"emacsclient\" sudo -e"

# Json
pretty_json() { cat $1 | python -m json.tool | less}
function pretty_csv {
    column -t -s, -n "$@" | less -F -S -X -K
}
function pretty_tsv {
    column -t -s $'\t' -n "$@" | less -F -S -X -K
}

# Increase Jupyter notebook memory
alias jnb='jupyter notebook --NotebookApp.iopub_data_rate_limit=10000000'
alias py='python'
alias py2='python2'
alias py3='python3'
alias zshrc='source ~/.zshrc'


# Colored list directory
alias grep='grep --color=auto'

# Mkdir and then cd to it
mkdircd ()
{
    mkdir -p -- "$1" &&
        cd -P -- "$1"
}

ag-replace() { ag -0 -l "$1" | xargs -0 perl -pi.bak -e "s/$1/$2/g"; }

# G stuff
alias fu=fileutil
if [ -f "/etc/bash_completion.d/hgd" ]; then
  source /etc/bash_completion.d/hgd
fi

# Koen's docker rviz
if  type xhost > /dev/null; then
    xhost +local:docker > /dev/null
    DOCKER_COMMON_ARGS="--gpus all --env=DISPLAY --env=XDG_RUNTIME_DIR --env=QT_X11_NO_MITSHM=1 --device=/dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /etc/localtime:/etc/localtime:ro"
fi

# Import API tokens
if [[ -f ~/.secrets ]]; then
    . ~/.secrets
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
