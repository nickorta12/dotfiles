# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

source "$HOME/.zshlib"


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
alias fs='ssh fs'

export EDITOR="nvim"
export PAGER="less -rF"
export BAT_PAGER="less -iRF"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH

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
    local command_type="$(whence -w "$1" | cut -d" " -f2)"
    case "$command_type" in
        function)
            whence -f "$1" | bat -lzsh
            ;;
        alias)
            which "$1" | bat -lzsh
            ;;
        command)
            bat $(which "$1")
            ;;
        *)
            echo "Invalid command to view"
            return 1
            ;;
    esac
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
    ls --color=never -1 $VENV_HOME
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

# Virtualenv support

virtual_env_prompt () {
    if [[ "${VIRTUAL_ENV}" =~ pypoetry ]]; then
        _dir=(${(s.-.)VIRTUAL_ENV##*/})
        _l=$((${#_dir} - 2))
        REPLY="(${(j.-.)_dir[@]:0:$_l}) "
    else
        REPLY=${VIRTUAL_ENV+(${VIRTUAL_ENV:t}) }
    fi
}

if ! grml_theme_has_token virtual-env; then
    grml_theme_add_token  virtual-env -f virtual_env_prompt '%F{magenta}' '%f'
fi
zstyle ':prompt:grml:left:setup' items rc virtual-env change-root user at host path vcs percent
zstyle ':prompt:grml:right:setup' items
#zstyle ':prompt:grml:left:setup' items rc virtual-env change-root user at host vcs percent

alias prompt-two-line="prompt nick 8bit black blue blue white yellow"
#prompt off
prompt grml

#source <(/usr/bin/starship init zsh --print-full-init)

## ZLE tweaks ##

## use the vi navigation keys (hjkl) besides cursor keys in menu completion
#bindkey -M menuselect 'h' vi-backward-char        # left
#bindkey -M menuselect 'k' vi-up-line-or-history   # up
#bindkey -M menuselect 'l' vi-forward-char         # right
#bindkey -M menuselect 'j' vi-down-line-or-history # bottom

## set command prediction from history, see 'man 1 zshcontrib'
#is4 && zrcautoload predict-on && \
#zle -N predict-on         && \
#zle -N predict-off        && \
#bindkey "^X^Z" predict-on && \
#bindkey "^Z" predict-off

## press ctrl-q to quote line:
#mquote () {
#      zle beginning-of-line
#      zle forward-word
#      # RBUFFER="'$RBUFFER'"
#      RBUFFER=${(q)RBUFFER}
#      zle end-of-line
#}
#zle -N mquote && bindkey '^q' mquote

## define word separators (for stuff like backward-word, forward-word, backward-kill-word,..)
#WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' # the default
#WORDCHARS=.
#WORDCHARS='*?_[]~=&;!#$%^(){}'
#WORDCHARS='${WORDCHARS:s@/@}'

# just type '...' to get '../..'
#rationalise-dot() {
#local MATCH
#if [[ $LBUFFER =~ '(^|/| |	|'$'\n''|\||;|&)\.\.$' ]]; then
#  LBUFFER+=/
#  zle self-insert
#  zle self-insert
#else
#  zle self-insert
#fi
#}
#zle -N rationalise-dot
#bindkey . rationalise-dot
## without this, typing a . aborts incremental history search
#bindkey -M isearch . self-insert

#bindkey '\eq' push-line-or-edit

## some popular options ##

## add `|' to output redirections in the history
#setopt histallowclobber

## try to avoid the 'zsh: no matches found...'
setopt nonomatch

## compsys related snippets ##

## changed completer settings
#zstyle ':completion:*' completer _complete _correct _approximate
#zstyle ':completion:*' expand prefix suffix

## another different completer setting: expand shell aliases
#zstyle ':completion:*' completer _expand_alias _complete _approximate

## to have more convenient account completion, specify your logins:
#my_accounts=(
# {grml,grml1}@foo.invalid
# grml-devel@bar.invalid
#)
#other_accounts=(
# {fred,root}@foo.invalid
# vera@bar.invalid
#)
#zstyle ':completion:*:my-accounts' users-hosts $my_accounts
#zstyle ':completion:*:other-accounts' users-hosts $other_accounts

## add grml.org to your list of hosts
#hosts+=(grml.org)
#zstyle ':completion:*:hosts' hosts $hosts

## aliases ##

## get top 10 shell commands:
alias top10='print -l ${(o)history%% *} | uniq -c | sort -nr | head -n 10'

## miscellaneous code ##

## variation of our manzsh() function; pick you poison:
manzsh()  { /usr/bin/man zshall |  less +/"$1" ; }

## Handy functions for use with the (e::) globbing qualifier (like nt)
#contains() { grep -q "$*" $REPLY }
#sameas() { diff -q "$*" $REPLY &>/dev/null }
#ot () { [[ $REPLY -ot ${~1} ]] }

# List all occurrences of programm in current PATH
plap() {
    emulate -L zsh
    if [[ $# = 0 ]] ; then
        echo "Usage:    $0 program"
        echo "Example:  $0 zsh"
        echo "Lists all occurrences of program in the current PATH."
    else
        ls -l ${^path}/*$1*(*N)
    fi
}

# Find out which libs define a symbol
lcheck() {
    if [[ -n "$1" ]] ; then
        nm -go /usr/lib/lib*.a 2>/dev/null | grep ":[[:xdigit:]]\{8\} . .*$1"
    else
        echo "Usage: lcheck <function>" >&2
    fi
}

# Download a file and display it locally
uopen() {
    emulate -L zsh
    if ! [[ -n "$1" ]] ; then
        print "Usage: uopen \$URL/\$file">&2
        return 1
    else
        FILE=$1
        MIME=$(curl --head $FILE | \
               grep Content-Type | \
               cut -d ' ' -f 2 | \
               cut -d\; -f 1)
        MIME=${MIME%$'\r'}
        curl $FILE | see ${MIME}:-
    fi
}

# Memory overview
memusage() {
    ps aux | awk '{if (NR > 1) print $5;
                   if (NR > 2) print "+"}
                   END { print "p" }' | dc
}

# print hex value of a number
hex() {
    emulate -L zsh
    if [[ -n "$1" ]]; then
        printf "%x\n" $1
    else
        print 'Usage: hex <number-to-convert>'
        return 1
    fi
}

# ctrl-s will no longer freeze the terminal.
stty erase "^?"
