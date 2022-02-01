# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$HOME/.antigen.zsh"
antigen init ~/.antigenrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh


# ==============================================================
#                         My Custom Stuff
# ==============================================================
alias ls='exa'
alias la='exa -la'
alias l='exa -lg'
alias ll='exa -lg'
alias sl='exa'
alias g='git'
alias cloc='tokei'
alias ariadl='aria2c -j12 -x12 -s12 -k1M'
alias zshreload='. $HOME/.zshrc'
alias zshedit='nvim $HOME/.zshrc && zimfw build'
alias nvimedit='nvim ~/.config/nvim/init.vim'
alias pywork='workond && c.'
alias rgl='rgless'
alias tn='tmux neww'
alias gd='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias vimdiff='nvim -d'
alias c.='code .'

export PAGER="less -rF"
export BAT_PAGER="less -iRF"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

fpath=(~/zsh $fpath)
fpath+=(/opt/homebrew/share/zsh/site-functions/)

# Custom functions
rangermux() {
    local session
    session="${PWD:t}"
    tmux new-session -ds "$session" -n ranger ranger
    tmux select-pane -T "$session" -t "$session:0"
    tmux attach-session -t "$session"
}

rgless() {
    rg --pretty $@ | less -FR
}

cdtop() {
    TOP_LEVEL=`git rev-parse --show-toplevel 2>/dev/null`
    if [ $? -eq 0 ]; then
        cd $TOP_LEVEL
    fi
}

# Starts a program fully in the background
back() {
   $@ >/dev/null 2>&1 &|
}

sudoback() {
    sudo -v
    sudo $@ >/dev/null 2>&1 &|
}

_back() {
    _arguments \
        ':commands:_command_names -e' \
        '*:: :_normal'
}
compdef _back back
compdef _back sudoback

catwhich() {
    if [[ -z "$1" ]]; then
        echo "Enter command name"
        return 1
    fi
    bat $(which "$1")
}

_catwhich() {
    _command_names -e
}
compdef _catwhich catwhich
alias batwhich='catwhich'

vimwhich() {
    if [[ -z "$1" ]]; then
        echo "Enter command name"
        return 1
    fi
    nvim $(which "$1")
}
compdef _catwhich catwhich
compdef _catwhich vimwhich

## Virtual environment management
export VENV_HOME="$HOME/.venvs"
[[ -d $VENV_HOME ]] || mkdir $VENV_HOME

venv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      source "$VENV_HOME/$1/bin/activate"
  fi
}

mkvenv() {
    if [ $# -eq 0 ]; then
        echo "Please provide venv name"
    else
        python3 -m venv "$VENV_HOME/$1"
        venv "$1"
        pip install --upgrade pip > /dev/null
        pip install wheel > /dev/null
    fi
}

rmvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      rm -r $VENV_HOME/$1
  fi
}

lsvenv(){
    ls $VENV_HOME --color=never -1
}

mkvenvd() {
    mkvenv "${PWD##*/}"
}

alias workon="venv"
alias mkvirtualenvd="mkvenvd"

workond() {
    venv_type="$(_check_workond.py)"
    if [ "$venv_type" = "POETRY" ]; then
        source "$(_get_poetry_venv.py)"
    elif [ "$venv_type" = "VENV" ]; then
        venv "${PWD##*/}"
    else
        echo "Not a poetry or venv dir"
        return 1
    fi
}

_venv() {
    compadd $(lsvenv)
}
compdef _venv venv
compdef _venv rmvenv

## /venv

_cd_common() {
    cd "$1"
    shift
    _cd $@
}

cdc() {
    cd ~/code/"$1"
}

_cdc() {
    _cd_common $HOME/code
}
compdef _cdc cdc

cdcp() {
    cd $HOME/code/playground/"$1"
}

_cdcp() {
    _cd_common $HOME/code/playground
}
compdef _cdcp cdcp

cdr() {
    cd ~/repos/"$1"
}

_cdr() {
    _cd_common $HOME/repos
}
compdef _cdr cdr
