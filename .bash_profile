# .bash_profile
#
# The purpose of this is to set up an initial environment 
#
# This profile attempts to be a common bash environment setup file
# for all my Unix-like systems I use at work.  Probably a bit
# too much CentOS oriented.  Before GIT and when diskspace was 
# expensive, developers sometimes shared a development environment.
# The reference SDE below stand for such a shared development
# environment.  I also build software under my home directory.
#
# Non-existent path and duplicate path elements will be delt 
# with near end of script.

#
## Track how many times this file gets sourced.
export BASH_PROFILE_SOURCED=${BASH_PROFILE_SOURCED:=0}

#
## Get aliases and functions
[[ -f ~/.bashrc ]] &&  . ~/.bashrc

#
## Set default mask so other members of a unix group can share a
## software development environment (SDE).
umask 0007

#
## Make sure MANPATH is sane.  Set it to what /etc/man.config
## would cause man to default to if MANPATH not set.
export MANPATH=${MANPATH:=/usr/man:/usr/share/man:/usr/local/man:/usr/local/share/man:/usr/X11R6/man}

#
## Setup shared development environment on shared workstations.
PATH=/home/SDE/bin:$PATH

#
## Kerberos utilities for HPC supercomputer access.
PATH=/usr/local/ossh/bin:/usr/local/krb5/bin:$PATH
MANPATH=/usr/local/ossh/man:$MANPATH

#
## Java8 Setup
PATH=~/opt/jdk8/bin:$PATH
PATH=/opt/jdk8/bin:$PATH
PATH=/home/SDE/opt/jdk8/bin:$PATH
MANPATH=~/opt/jdk8/man:$MANPATH
MANPATH=/opt/jdk8/man:$MANPATH
MANPATH=/home/SDE/opt/jdk8/man:$MANPATH

#
## Setup Scala system wide.
## Now a days, I just use SBT for this.
PATH=~/opt/scala/bin:$PATH
PATH=/opt/scala/bin:$PATH
PATH=/home/SDE/opt/scala/bin:$PATH
MANPATH=~/opt/scala/man:$MANPATH
MANPATH=/opt/scala/man:$MANPATH
MANPATH=/home/SDE/opt/scala/man:$MANPATH

#
## OpenMPI Setup for my workstation (Put toward end of
## paths to avoid any possible collisions on HPC supercomputers)
PATH=$PATH:/usr/lib64/openmpi/bin
PATH=/data/local/bin:$PATH
PATH=$PATH:/usr/lib64/openmpi/1.4-gcc/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/openmpi/lib

#
## Usual user stuff (in case System Admins messed up /etc/profile)
PATH=$PATH:/usr/local/bin:/usr/bin:/bin
 
#
## For external packages built locally in home directory
PATH=~/local/bin:$PATH
MANPATH=~/local/share/man:$MANPATH
# For local software builds: 
if [[ -d ~/local/lib/atlas ]]
then
    LD_LIBRARY_PATH=~/local/lib/atlas/lib:$LD_LIBRARY_PATH
    export ATLAS=~/local/lib/atlas/lib
    export LAPACK=~/local/lib/atlas/lib
fi

#
## System Stuff
PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin

#
## Personal bin directory - policy is to defer to all others' names.
## (Usi ~/local/bin to overide others' names)
PATH=$PATH:~/bin:.

#
## Clean up PATHS
[[ -x ~/bin/pathTrim ]] && {
    PATH=$(~/bin/pathTrim $PATH)
    LD_LIBRARY_PATH=$(~/bin/pathTrim $LD_LIBRARY_PATH)
    MANPATH=$(~/bin/pathTrim $MANPATH)
}

#
## Let Linux be Linux.
## No sense letting things like ps follow the useless and bad parts
## of the Unix98 standard.
[[ $(uname) == Linux ]] && {
    export CMD_ENV=linux
    export PS_PERSONALITY=linux
}

#
## Count number of times file sourced
((BASH_PROFILE_SOURCED++))
