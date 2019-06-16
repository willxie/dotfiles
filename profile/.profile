# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

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

# Do os specific things
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    # Emacsclient and disown
    ec() { emacsclient "$@" &! }


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
else
    echo "OS type unknown, shell setup could be bad"
fi

# More colors
export TERM="xterm-256color"

# Json
prettyjson() { cat $1 | python -m json.tool | less}
alias pj='prettyjson'

# Increase Jupyter notebook memory
alias jnb='jupyter notebook --NotebookApp.iopub_data_rate_limit=10000000'
alias py='python2'
alias py3='python3'

# Colored list directory
alias grep='grep --color=auto'

# Mkdir and then cd to it
mkdircd ()
{
    mkdir -p -- "$1" &&
        cd -P -- "$1"
}

# Nautilus without annoying desktop
alias N='nautilus --no-desktop&'

# CUDA
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:/usr/local/_cuda/lib64/:/usr/local/_cuda/extras/CUPTI/lib64/:/usr/local/cuda/extras/CUPTI/lib64/:$LD_LIBRARY_PATH

# Google cloud
# export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/segmentation-training-539ed1f38bb6.json
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/wxie/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/wxie/Downloads/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/wxie/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/wxie/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
alias gls='gsutil -m ls'
alias gll='gsutil -m ls'
alias grm='gsutil -m rm'
alias gmv='gsutil -m mv'
alias gcp='gsutil -m  cp'
alias gcat='gsutil -m cat'
alias grsync='gsutil -m rsync'
alias gdu='gsutil -m du -sch'

# ROS stuff
[ -s /home/wxie/cruise/setup/../ros/scripts/run_setup.sh ] && . /home/wxie/cruise/setup/../ros/scripts/run_setup.sh
alias roscoresim='roscore &; sleep 4s &&  rosparam set use_sim_time true && fg'
alias roskill='~/cruise/ros/scripts/stop_ros.sh'
alias cruise='cd ~/cruise'
alias ans="cd ~/cruise/setup;./run_ansible.sh"
export ANSIBLE_COW_SELECTION=random


# For running circle jobs
export CIRCLE_TOKEN=46c08a4cee823b3b980c8579e269d95c8254264b
