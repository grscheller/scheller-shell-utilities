# .bashrc

# Used for all my Unix/Unix-like environments at work.

##
## Source global definitions - in case the gods know better.
if [[ -f /etc/bashrc ]]; then
	source /etc/bashrc
fi

##
## Source temporary aliases and functions
if [[ -f ~/.bashrc_myTemps ]]; then
	source ~/.bashrc_myTemps
fi

##
## Setup locale as so python3 and other applications prints unicode correctly.
export LANG=en_US.utf8

##
## Set default mask so other members of a unix group can share a
## development environment. ( Fixes what /etc/bashrc breaks at
## work due to misguided DISA system "hardening". )
umask 0007

##
## Setup aliases and shell functions
# The 2> /dev/null is in case commands were not aliased.
unalias rm 2> /dev/null
unalias ls 2> /dev/null
# ls family of aliases
alias l1='ls -1'
alias lc='ls --color=auto'
alias la='ls -a'
alias la1='ls -a -1'
alias ll='ls -ltr'
alias lla='ls -ltra'
alias l.='ls -dA .* --color=auto'
alias lS='ls -Ssr'

##
## Alias to display processes in a nice hierarchical tree
alias pst="ps axjf | sed -e '/^ PPID.*$/d' -e's/.*:...//'"

## wget options to pulldown websites
# Pull down a subset of a website -- Sometimes not enough
alias Wget='wget -p --convert-links -e robots=off'
# Pull down more -- Not good for large websites
alias WgetMirror='wget --mirror -p --convert-links -e robots=off'

## which alias
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

## Work aliases and functions

# Kerberos alias for supercomputer access
alias khpc='kinit userName3@foo.mySchool.edu'

# ssh aliases

alias rygar='/usr/bin/ssh userName@rygar'
alias galaga='/usr/bin/ssh userName2@galaga'
alias frogger='/usr/bin/ssh userName@frogger'
alias foobar='/usr/bin/ssh userName3@bar.mySchool.edu'

# scp shell functions (use via aliases)

function toSystem() {
  user=$1; system=$2
  shift 2
  /usr/bin/scp -r "$@" ${user}@${system}:Catch
}

function fromSystem() {
  user=$1; system=$2
  shift 2
  for each in "$@"
  do
      /usr/bin/scp -r ${user}@${system}:"${each}" .
  done
}

# scp aliases - if used in scripts, you need to use
#               "shopt -s expand_aliases" in the script.
#
#               replace userName with your login on each of these systems

alias toRygar='toSystem userName rygar'
alias fromRygar='fromSystem userName rygar'

alias toGalaga='toSystem userName2 galaga'
alias fromGalaga='fromSystem userName2 galaga'

alias toFrogger userName frogger'
alias fromFrogger userName frogger'

alias toBar='toSystem userName3 bar.mySchool.edu'
alias fromBar='fromSystem userName3 bar.mySchool.edu'

## LibreOffice writer
function low() {
    /usr/lib64/libreoffice/program/oosplash --writer "$@" &
}

## PDF readed evince
function ev() {
    evince "$@" &
}

## Convert between hex and dec
function h2d() {
    echo "ibase=16; $@" | bc
}
function d2h() {
    echo "obase=16; $@" | bc
}

##
## Setup GUI-land utilities

## select file manager
if [[ -x /usr/bin/thunar ]]
then
     alias fm='/usr/bin/thunar &'
elif [[ -x /usr/bin/nautilus ]]
then
   alias fm=/usr/bin/nautilus
else
   alias fm=explorer
fi

## Run terminal emulator in environment of parent shell.
## That way the shell running in the new terminal emulator
## inherits the environment of the shell running in 
## another terminal emmulator and not that of the terminal
## server daemon.  Mostly for the local machine, but on
## a trusted network, I have used this with ssh port forwading
## where the terminal is running on a remote machine but
## displayed back to the local one.
if [[ -x /usr/bin/gnome-terminal ]]
then
   # Run in a subshell to gag job control chatter
   alias tm='( /usr/bin/gnome-terminal --disable-factory &>/dev/null & )'
else
   alias tm='( /usr/bin/xterm & )'
fi

##
## Misc. bash modifcations
set -o notify  # Don't wait until next prompt to report status of bg jobs
set -o pipefail  # return right most nonzero error, otherwise 0
shopt -s extglob  # turn on extended pattern matching
shopt -s checkwinsize
shopt -s checkhash    # Checks if hashed cmd exists, otherwise search path.

##
## Set up command line history and editing
##    I have written entire shell scripts within my shell
##    history this way.
set -o vi         # Cmdline editting like vi editor
shopt -s cmdhist     # Store multiline commands as single entry in history
shopt -s lithist     # and store with embedded whitespace, not ;.
shopt -s histappend    # Append, don't replace history file.
HISTSIZE=2000
HISTFILESIZE=5000
HISTCONTROL="ignoredups"
PROMPT_COMMAND='history -a'   # Whenever Displaying $PS1,
                              # save the last cmd to disk.

##
## Xterm title setup - display nice names, similar to the DNS aliases,
##                     not the ugly ones given by the system admins
export HOST=${HOSTNAME%%.*}
if [[ $TERM == xterm ]] 
then
     case $HOST in
         drxrytl410kzv)
             HOST=rygar
             ;;
         kseyfdxnzjt52)
             HOST=galaga
             ;;
         ghhebxl15166l)
             HOST=frogger
             ;;
     esac
     PROMPT_COMMAND='history -a; echo -ne "\033]0;${USER}@${HOST}\007"'
fi

## Prompt setup - multiline prompt (try it, you'll like it)
PS1='\n[\u@${HOST} \w]\n$ '
PS2='> '
PS3='> '
PS4='+ '

##
## Defaults if X-Windows not configured.
export DISPLAY=${DISPLAY:=:0.0}    # In case DISPLAY not set, an educated
                                   # guess of what it will be when I bring
                                   # X up.  Mostly for the cygwin env.

##
## Count number of time file sourced
export BASHRC_SOURCED=${BASHRC_SOURCED:=0}
((BASHRC_SOURCED++))

