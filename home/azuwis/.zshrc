# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
setopt appendhistory autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/azuwis/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

### Begin: added by azuwis

# verify history cmd before exec
setopt hist_verify extended_glob

# processes command, better for kill command completion
#zstyle ':completion:*:processes' command 'ps -u $USER -o pid,%cpu,cputime,cmd'

# from http://www.zsh.org/mla/users/2008/msg00927.html
pids4kill() {
    local -a ps

    # This is using inside knowledge of the implementation.
    # Not guaranteed to work across upgrades, but likely to.
    if [[ $oldcontext = *:sudo:* ]]
    then
        # More inside knowledge:  Peek at the sudo options.
        # Also not guaranteed to work across upgrades.
        local u=$opt_args[-u]
        if [[ -n $u ]]
        then
            ps=(ps -u $u)
        else
            ps=(ps -u root)
        fi
    else
        ps=(ps -u $USER)
    fi
    $ps -o pid,%cpu,cputime,cmd
}
#zstyle ':completion:*:*:kill:*' command pids4kill
zstyle ':completion:*:processes' command pids4kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

if [[ "$TERM" != "dumb" ]]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
    alias grep='grep -i --color=auto'
    export LV="-c"
    export RI="-f ansi"
    export LESS="-R"
fi

alias ee='emacs -nw'

# set PATH and other ENV
#export CLICOLOR=1
#export LSCOLORS=gxfxaxdxcxegedabagacad
#export PATH=$PATH:~/bin
export DEBEMAIL=azuwis@163.org

# append command to history file once executed
#setopt inc_append_history

# make <TAB> complition ignore everything under and to the right of the cursor
#bindkey '^i' expand-or-complete-prefix

# To have zsh complete ssh hosts out of your .ssh/known_hosts add this
#local _myhosts
#_myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
#zstyle ':completion:*' hosts $_myhosts

# set prompt
#. ~/bin/set-prompt
BLACK="%{"$'\033[01;30m'"%}"
GREEN="%{"$'\033[01;32m'"%}"
RED="%{"$'\033[01;31m'"%}"
YELLOW="%{"$'\033[01;33m'"%}"
BLUE="%{"$'\033[01;34m'"%}"
BOLD="%{"$'\033[01;39m'"%}"
NORM="%{"$'\033[00m'"%}"
export PS1="${GREEN}%n@%m ${BLUE}%~ ${RED}%(?..%? )
${BLUE}%# ${NORM}"

# '/' is not a wordchar
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# echo todo
# echo TODO:
# cat ~/work/TODO

#To color your stderr
#exec 2>>(while read line; do
#  print '\e[91m'${(q)line}'\e[0m' > /dev/tty; done &)

# run fortune debian hint
#/usr/games/fortune /usr/share/games/fortunes/debian-hints

### GNU screen staff
# if using GNU screen, let the zsh tell screen what the title and hardstatus
# of the tab window should be.
if [[ $TERM == "screen" ]]; then
  # use the current user as the prefix of the current tab title (since that's
  # fairly important, and I change it fairly often)
  TAB_TITLE_PREFIX='"${USER}$PROMPT_CHAR"'
  # when at the shell prompt, show a truncated version of the current path (with
  # standard ~ replacement) as the rest of the title.
  TAB_TITLE_PROMPT='`echo $PWD | sed "s/^\/Users\//~/;s/^~$USER/~/;s/\/..*\//\/...\//"`'
  # when running a command, show the title of the command as the rest of the
  # title (truncate to drop the path to the command)
  #TAB_TITLE_EXEC='$cmd[1]:t'
  TAB_TITLE_EXEC='`case $cmd[1]:t in ; "ssh") echo $cmd[2]:t;; *) echo $cmd[1]:t;; esac`'
 
  # use the current path (with standard ~ replacement) in square brackets as the
  # prefix of the tab window hardstatus.
  #TAB_HARDSTATUS_PREFIX='"[`echo $PWD | sed "s/^\/Users\//~/;s/^~$USER/~/"`] "'
  TAB_TITLE_PROMPT='`print -Pn "%~" | sed "s:\([~/][^/]*\)/.*/:\1...:"`'
  # when at the shell prompt, use the shell name (truncated to remove the path to
  # the shell) as the rest of the title
  #TAB_HARDSTATUS_PROMPT='$SHELL:t'
  TAB_HARDSTATUS_PREFIX='`print -Pn "[%~] "`'
  # when running a command, show the command name and arguments as the rest of
  # the title
  TAB_HARDSTATUS_EXEC='$cmd'
 
  # tell GNU screen what the tab window title ($1) and the hardstatus($2) should be
  function screen_set()
  {  
    #  set the tab window title (%t) for screen
    print -nR $'\033k'$1$'\033'\\\

    # set hardstatus of tab window (%h) for screen
    print -nR $'\033]0;'$2$'\a'
  }
  # called by zsh before executing a command
  function preexec()
  {
    local -a cmd; cmd=(${(z)1}) # the command string
    #eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_EXEC"
    eval "tab_title=$TAB_TITLE_EXEC"
    eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_EXEC"
    screen_set $tab_title $tab_hardstatus
  }
  # called by zsh before showing the prompt
  function precmd()
  {
    eval "tab_title=$TAB_TITLE_PROMPT"
    eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_PROMPT"
    screen_set $tab_title $tab_hardstatus
  }
fi
### END: GNU screen staff

### END: added by azuwis
