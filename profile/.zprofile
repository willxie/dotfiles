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
# # if running bash
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
# 	. "$HOME/.bashrc"
#     fi
# fi

# # set PATH so it includes user's private bin if it exists
# if [ -d "$HOME/bin" ] ; then
#     PATH="$HOME/bin:$PATH"
# fi

# Do OS specific things
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    # Emacsclient and disown
    function ec() { emacsclient "$@" &! }


elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    alias emacs='open -a /Applications/Emacs.app $1'
    alias ec='open -a /Applications/Emacs.app $1'
    # alias ec='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient'

    # Compile
    # alias gcc='/usr/local/bin/gcc-6 -std=c++11'
    # alias g++='/usr/local/bin/g++-6 -std=c++11'
    # alias gccc='/usr/local/bin/gcc-6 -std=c++11 -Werror -Wall -Wextra'
    # alias g+++='/usr/local/bin/g++-6 -std=c++11 -Werror -Wall -Wextra'

    # Homebrew
    alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'

    # GoogleCloud and python3.8 compatibility issues
    export CLOUDSDK_PYTHON=/usr/bin/python2.7
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
alias py3='python3.7'
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

# Golang
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Nautilus without annoying desktop
alias N='nautilus --no-desktop&'

# Ros stuff
[ -s ~/cruise/setup/../ros/scripts/run_setup.sh ] && . ~/cruise/setup/../ros/scripts/run_setup.sh
alias roscoresim='roscore &; sleep 4s &&  rosparam set use_sim_time true && fg'
alias roskill='~/cruise/ros/scripts/stop_ros.sh'
alias cruise='cd ~/cruise'
alias vivarium='cd ~/vivarium'
alias robotorch='cd ~/robotorch'
alias ans="cd ~/cruise/setup;./run_ansible.sh"
export ANSIBLE_COW_SELECTION=random

# CUDA
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/extras/CUPTI/lib64/:$LD_LIBRARY_PATH
# export PATH=$PATH:/usr/local/cuda/bin

# Google cloud
# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/google-cloud-sdk/path.zsh.inc' ]; then . '~/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '~/google-cloud-sdk/completion.zsh.inc' ]; then . '~/google-cloud-sdk/completion.zsh.inc'; fi

export BOTO_CONFIG='~/.config/gcloud/legacy_credentials/will.xie@getcruise.com/.boto'
alias gls='gsutil -m ls'
alias gll='gsutil -m ls'
alias grm='gsutil -m rm'
alias gmv='gsutil -m mv'
alias gcp='gsutil -m  cp'
alias gcat='gsutil -m cat'
alias grsync='gsutil -m rsync'
alias gdu='gsutil -m du -sch'

# Enable [] in pip
# alias pip='noglob pip'

# For running circle jobs
export KUBECONFIG=~/.kube/config.d/$(whoami).conf

# Pointnet
alias pointnet='cd ~/frustum-pointnets'

# # Powerline on mac
# source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme

# Bless refind
bless-refind () {
    sudo mkdir /Volumes/ESP && sudo mount -t msdos /dev/disk0s1 /Volumes/ESP;
    sudo bless --mount /Volumes/ESP --setBoot --file /Volumes/ESP/EFI/refind/refind_x64.efi --shortform;
}

# Vivarium login
export VAULT_ADDR="https://vault.secure.car:8200"
export CLOUDSDK_PYTHON=$(which python3)

# Koen's docker rviz
if  type xhost > /dev/null; then
    xhost +local:docker > /dev/null
    DOCKER_COMMON_ARGS="--gpus all --env=DISPLAY --env=XDG_RUNTIME_DIR --env=QT_X11_NO_MITSHM=1 --device=/dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /etc/localtime:/etc/localtime:ro"
fi

# Import API tokens
if [[ -f ~/.secrets ]]; then
    . ~/.secrets
fi
