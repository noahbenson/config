#! /bin/bash
####################################################################################################
# .profile
# Shell initialization for environment variables and functions (but not aliases and things not
# duplicated in subshells, which go in .bashrc).

# some handy environment variables
export EDITOR=/opt/local/bin/emacs
export VISUAL=/opt/local/bin/emacs

# ANSI colors for BASH prompt
ANSI_RESET="\[\e[0m\]"
ANSI_BOLD="\[\e[1m\]"
ANSI_UNDERLINE="\[\e[4m\]"
ANSI_BLINK="\[\e[5m\]"
ANSI_REVERSE="\[\e[7m\]"
ANSI_BLACK="\[\e[30m\]"
ANSI_RED="\[\e[31m\]"
ANSI_GREEN="\[\e[32m\]"
ANSI_YELLOW="\[\e[33m\]"
ANSI_BLUE="\[\e[34m\]"
ANSI_PURPLE="\[\e[35m\]"
ANSI_CYAN="\[\e[36m\]"
ANSI_WHITE="\[\e[37m\]"
ANSI_RESET_COLOR="\[\e[39m\]"
ANSI_BOLD_BLACK="\[\e[1;30m\]"
ANSI_BOLD_RED="\[\e[1;31m\]"
ANSI_BOLD_GREEN="\[\e[1;32m\]"
ANSI_BOLD_YELLOW="\[\e[1;33m\]"
ANSI_BOLD_BLUE="\[\e[1;34m\]"
ANSI_BOLD_PURPLE="\[\e[1;35m\]"
ANSI_BOLD_CYAN="\[\e[1;36m\]"
ANSI_BOLD_WHITE="\[\e[1;37m\]"
ANSI_BG_BLACK="\[\e[40m\]"
ANSI_BG_RED="\[\e[41m\]"
ANSI_BG_GREEN="\[\e[42m\]"
ANSI_BG_YELLOW="\[\e[43m\]"
ANSI_BG_BLUE="\[\e[44m\]"
ANSI_BG_PURPLE="\[\e[45m\]"
ANSI_BG_CYAN="\[\e[46m\]"
ANSI_BG_WHITE="\[\e[47m\]"
ANSI_RESET_BG_COLOR="\[\e[49m\]"
# change prompt...
export PS1="${ANSI_BOLD}${ANSI_YELLOW}\u@\h ${ANSI_RESET}[${ANSI_RED}\j${ANSI_RESET}] ${ANSI_BLUE}\w${ANSI_RESET}\$ "

# this weird mac os x variable that ruins rsync
export COPYFILE_DISABLE=1

# Java classpaths and home...
if [ -d "$HOME/Library/Java/Classes" ]
then export CLASSPATH="$CLASSPATH:$HOME/Library/Java/Classes"
fi
if [ -d "$HOME/Library/Java/Jars" ]
then for flnm in "$HOME/Library/Java/Jars"/*.jar
     do CLASSPATH="$CLASSPATH:${flnm}"
     done
     export CLASSPATH
fi
export JAVA_HOME="`/usr/libexec/java_home`"

# Mathematica Stuff
if [ -z "$MATHEMATICA_ROOT" ] && [ -d "/Applications/Mathematica.app" ]
then export MATHEMATICA_ROOT="/Applications/Mathematica.app/Contents"
fi

# FreeSurfer Paths
if [ -z "$FREESURFER_HOME" ] && [ -d "/Applications/freesurfer" ]
then export FREESURFER_HOME=/Applications/freesurfer
     export NO_FSFAST=1
     if [ -z "$FREESURFER_INITIALIZED" ]
     then source "$FREESURFER_HOME/FreeSurferEnv.sh" &> "$HOME/.FreeSurferEnv.sh.log"
          export FREESURFER_INITIALIZED=yes
     fi
fi

# Matlab Stuff
if [ -z "$MATLAB_ROOT" ] && [ -d "/Applications/MATLAB" ]
then export MATLAB_ROOT=/Applications/MATLAB
fi

# Anaconda/Miniconda stuff
if [ -r "$HOME/Library/anaconda3/etc/profile.d/conda.sh" ]
then source "$HOME/Library/anaconda3/etc/profile.d/conda.sh"
fi
if [ -r "$HOME/Library/miniconda3/etc/profile.d/conda.sh" ]
then source "$HOME/Library/miniconda3/etc/profile.d/conda.sh"
fi
# This block is formatted strangely because we want to wrap the auto-code in an if-statement
if [ -d "/anaconda3" ]
then 
# added by Anaconda3 2019.03 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<
conda activate nben
fi
# we want to add our own to the python path...
if [ -d "$HOME/Library/Python" ]
then if [ -z "$PYTHONPATH" ]
     then export PYTHONPATH="$HOME/Library/Python"
     else export PYTHONPATH="$HOME/Library/Python:$PYTHONPATH"
     fi
fi

# Utilities for the path...
function addpath {
    for dir in "$@"
    do if [ -z "`findpath \"$dir\"`" ]
       then PATH="${PATH}:${dir}"
       fi
    done
    export PATH
}
function showpath {
    local dirs
    IFS=":" read -a dirs <<< "$PATH"
    for dir in "${dirs[@]}"
    do echo "$dir"
    done
}
function findpath {
    local dirs
    IFS=":" read -a dirs <<< "$PATH"
    for dir in "${dirs[@]}"
    do if [ "$dir" = "$1" ]
       then echo "$dir"
       fi
    done
}

# The Path Definition
[ -d "~/Library/Scripts" ] && addpath "~/Library/Scripts"
[ -d "/usr/local/bin"    ] && addpath "/usr/local/bin"
[ -d "/opt/local/bin"    ] && addpath "/opt/local/bin"
[ -d "/opt/local/sbin"   ] && addpath "/opt/local/sbin"

[ -n "$FREESURFER_HOME"  ] && addpath "$FREESURFER_HOME/bin"
[ -n "$MATLAB_ROOT"      ] && addpath "$MATLAB_ROOT/bin"
[ -n "$MATHEMATICA_ROOT" ] && addpath "$MATHEMATICA_ROOT/bin"

# Some scripts for using freesurfer and mne subjects
function clearsub {
  export SUBJECT=""
  export SUBJECT_STACK=""
}
function pushsub {
  local subs
  IFS=":" read -a subs <<< "$SUBJECT_STACK"
  if [ -z "$1" ]
  then if [ ${#subs[@]} -lt 1 ]
       then echo "No subject to swap"
       else local tmp="$SUBJECT"
            export SUBJECT="${subs[${#subs[@]} - 1]}"
            subs[${#subs[@]} - 1]="$tmp"
       fi
  else subs[${#subs[@]}]="$SUBJECT"
       export SUBJECT="$1"
  fi
  SUBJECT_STACK="";
  for sub in "${subs[@]}"
  do if [ -z "$SUBJECT_STACK" ]
     then SUBJECT_STACK="$sub"
     else SUBJECT_STACK="${SUBJECT_STACK}:${sub}"
     fi
  done
  export SUBJECT_STACK
}
function popsub {
  local subs
  local sub
  local tmp=""
  IFS=":" read -a subs <<< "$SUBJECT_STACK"
  if [ -z "$SUBJECT" ]
  then echo "No subject to pop"
  else if [ "${#subs[@]}" = 0 ]
       then export SUBJECT=""
       else export SUBJECT="${subs[${#subs[@]} - 1]}"
            SUBJECT_STACK="";
            for sub in "${subs[@]}"
            do if [ -z "$tmp" ]
               then tmp="$sub"
               elif [ -z "$SUBJECT_STACK" ]
               then SUBJECT_STACK="$tmp"
               else SUBJECT_STACK="$SUBJECT_STACK:$tmp"
               fi
               tmp="$sub"
            done
            export SUBJECT_STACK
       fi
  fi
}
function subjects {
  local subs
  local sub
  IFS=":" read -a subs <<< "$SUBJECT_STACK"
  for sub in "${subs[@]}"
  do echo "$sub"
  done
  if [ -n "$SUBJECT" ]
  then echo "$SUBJECT"
  fi
}
if [ -z "$SUBJECT_STACK" ]
then export SUBJECT_STACK=""
fi
if [ -z "$SUBJECT" ]
then export SUBJECT=""
fi

