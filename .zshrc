# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  # Download zimfw script if missing.
  command mkdir -p ${ZIM_HOME}
  if (( ${+commands[curl]} )); then
    command curl -fsSL -o ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    command wget -nv -O ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# }}} End configuration added by Zim install

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


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
alias zshedit='nvim $HOME/.zshrc && zimfw build && zshreload'
alias nvimedit='nvim ~/.config/nvim/init.vim'
alias pywork='workond && c.'
alias rgl='rgless'
alias tn='tmux neww'
alias gd='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias vimdiff='nvim -d'

export PAGER="less -rF"
export BAT_PAGER="less -iRF"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:$PATH"
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

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
