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

# ROS stuff
[ -s /home/wxie/cruise/setup/../ros/scripts/run_setup.sh ] && . /home/wxie/cruise/setup/../ros/scripts/run_setup.sh

# More colors
export TERM="xterm-256color"

# Ansible
export ANSIBLE_COW_SELECTION=random
alias ans="cd ~/cruise/setup;./run_ansible.sh"

# Json
prettyjson() { cat $1 | python -m json.tool | less}
alias pj='prettyjson'

# Increase Jupyter notebook memory
alias jnb='jupyter notebook --NotebookApp.iopub_data_rate_limit=100000000'
alias py='python'

# Google cloud
export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/segmentation-training-539ed1f38bb6.json

# Emacs
ec() { emacsclient "$@" &! }

# Mkdir and then cd to it
mkdircd ()
{
    mkdir -p -- "$1" &&
        cd -P -- "$1"
}

# Nautilus without annoying desktop
alias N='nautilus --no-desktop&'

# Cruise ros sim time
alias roscoresim='roscore &; sleep 4s &&  rosparam set use_sim_time true && fg'
alias roskill='~/cruise/ros/scripts/stop_ros.sh'
alias cruise='cd ~/cruise'
# For running circle jobs
export CIRCLE_TOKEN=46c08a4cee823b3b980c8579e269d95c8254264b


# CUDA
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:/usr/local/_cuda/lib64/:/usr/local/_cuda/extras/CUPTI/lib64/:/usr/local/cuda/extras/CUPTI/lib64/:$LD_LIBRARY_PATH

# Google cloud
alias gls='gsutil -m ls'
alias gll='gsutil -m ls'
alias grm='gsutil -m rm'
alias gmv='gsutil -m mv'
alias gcp='gsutil -m  cp'
alias gcat='gsutil -m cat'
alias grsync='gsutil -m rsync'
alias gdu='gsutil -m du -sch'
