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

eval "$(/opt/homebrew/bin/brew shellenv)"


# Do OS specific things
if [[ $(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip') == "microsoft" ]]; then
    # Windows WSL2, also run scripts in linux.
    alias open="explorer.exe"
    alias wsl-open="explorer.exe"
    CHROME_EXECUTABLE="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
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

    # Gcloud SDK
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
else
    echo "OS type unknown, shell setup could be bad"
fi




# Enable inline comment
setopt interactive_comments

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
alias git-branch-dates="git for-each-ref --sort=committerdate --format='%(refname:short) %(committerdate:iso8601)' refs/heads/ | awk '{ printf \"%-50s %s\n\", \$1, \$2 \" \" \$3 \" \" \$4 }'"
alias cosign='cd ~/projects/cosign/api_history_taking &&  source venv/bin/activate && cd ..'
alias cosignapp='cd ~/projects/cosign/api_history_taking &&  source venv/bin/activate && cd ../app_history'
alias cosignapi='cd ~/projects/cosign/api_history_taking &&  source venv/bin/activate && cd ../api_history_taking'

jupyter-lab-wsl() { jupyter-lab --ip $(python3 -c "import subprocess; subprocess.run(['hostname', '-I'], text=True).stdout") }
# alias nproc="sysctl -n hw.logicalcpu"

# Google cloud shortcuts
alias gls='gsutil -m ls'
alias gll='gsutil -m ls'
alias grm='gsutil -m rm'
alias gmv='gsutil -m mv'
alias gcp='gsutil -m  cp'
alias gcat='gsutil -m cat'
alias grsync='gsutil -m rsync'
alias gdu='gsutil -m du -sch'

# The fuck cli
eval $(thefuck --alias)
export THEFUCK_EXCLUDED_SEARCH_PATH_PREFIXES='/mnt/'

# Colored list directory
alias grep='grep --color=auto'

alias rsync='rsync -varP'
alias rsync-partial='rsync -hvrPt'

alias f='fuck'

# Mkdir and then cd to it
mkdircd ()
{
    mkdir -p -- "$1" &&
        cd -P -- "$1"
}

ag-replace() { ag -0 -l $1 | xargs -0 sed -ri.bak -e "s/$1/$2/g"; }
ag-replace-dry() { ag -0 -l $1 | xargs -0 sed -n -ri.bak -e "s/$1/$2/g"; }
ag-replace-pearl() { ag -0 -l "$1" | xargs -0 perl -pi.bak -e "s/$1/$2/g"; }

# export PATH="$PATH:/usr/local/anaconda3/bin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"
# Flutter and dart
export PATH="$PATH:/usr/local/flutter/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH:/usr/local/texlive/2023/bin/universal-darwin/" # MacTex
# export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# Ruby, gem, cocoapod
# export GEM_HOME=$HOME/.gem
# export PATH=$GEM_HOME/bin:$PATH
# export PATH=$HOME/.gem/bin:$PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"



export JAVA_HOME="$(/usr/libexec/java_home)"
export PATH="$HOME/.daml/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion