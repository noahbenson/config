#! /bin/bash
####################################################################################################
# .bashrc
# This file stores aliases and any other configuration item that needs to be loaded into subshells
# but isn't already loaded by login shells.

# aliases
alias ls='ls -G' # force color (on mac; on linux change to ls='ls --color=auto'
alias emacs='/opt/local/bin/emacs '

if [ -z "$MATHEMATICA_ROOT" ]
then alias math='"$MATHEMATICA_ROOT"/MacOS/MathKernel '
     alias mathscript='"$MATHEMATICA_ROOT"/MacOS/MathematicaScript '
fi
