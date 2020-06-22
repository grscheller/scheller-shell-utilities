#!/bin/ksh
# shellcheck shell=ksh
# shellcheck source=/dev/null
#
#    ~/.env_init
#
#  Configure initial values of $PATH and environment
#  variables you wish child processes, perhaps other
#  shells, to initially inherit.
#
#  This was traditionally done in .profile or .bash_profile
#  whenever a login shell was created.  Unfortunately,
#  in most Desktop Environments, the shells in terminal
#  emulators are not decendant from a login shell.
#
#  Non-existent path and duplicate path elements
#  will be dealt with near end of script.
#
#  This file is sourced by both bash and ksh, so is written
#  in a common subset of both.

## Sentinel value to mark completion of
#  an initial environment configuration.
(( ENV_INIT_LVL++ ))

## Default file permissions - group way too broad for work CentOS 7
if [[ ! -f /etc/redhat-release ]]
then
    umask u=rwx,g=rx,o=
else
    umask u=rwx,g=,o=
fi

export EDITOR=vim
export VISUAL=vim
#set -o vi  # vi editing-mode, set here if not configured in ~/.inputrc

## My e-mail addresses
export ME_HOVER='geoffrey@scheller.com'
export ME_GMAIL='grscheller@gmail.com'
export ME_WORK='geoffrey.scheller.1@us.af.mil'

## Set locale so applications (like Python3) display unicode correctly
export LANG=en_US.utf8

## Python configuration
export PYTHONPATH=lib:../lib
export PIP_REQUIRE_VIRTUALENV=true

## For Haskell locally contained and administered via stack
PATH=~/.local/bin:$PATH

## Location Rust Toolchain
PATH=~/.cargo/bin:$PATH

## Locally installed SBT (Scala Build Tool)
PATH=~/opt/sbt/bin:$PATH

## For Termux environment
PATH=$PATH:/data/data/com.termux/files/usr/bin/applets

## Put home bin directory near end
PATH=$PATH:~/bin

## Clean up PATH - remove duplicate entries
[[ -x ~/bin/pathtrim ]] && PATH=$(~/bin/pathtrim "$PATH")

## Put a relative bin directory at end of PATH, this is for projects
#  where my user takes up residence in the project's root directory.
[[ $PATH =~ :bin(:|$) ]] || PATH=$PATH:bin 
# Older version of ksh (pdksh & ksh88) don't support =~ regex matching
#[[ ($PATH == *:bin:*) || ($PATH == *:bin) ]] || PATH=$PATH:bin 

## Information for ssh configuration
#
#                  Host-Name           port   login
export    VOLTRON='rvsllschellerg2        22  schelleg'
export      KOALA='rvswlschellerg1        22  schelleg'
export LITTLEJOHN='rvswlwojcikj1          22  schelleg'
export    GAUSS17='gauss17             31502  grs'
export   MAXWELL4='maxwell4            29801  geoffrey'
export     EULER7='euler7                 22  grs'
