#! /bin/bash

function die {
    echo "$*"
    exit 1
}

# where is the script being run from:
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

cat <<EOF

================================================================================
This script installs the files from this repository into the directory $HOME.
It will fail if it encounters any of the files it would replace; i.e., your
.bashrc file will not be overwritten if you forgot to back it up.

This script will symlink the following files in your home directory to the
equivalent files in the directory $SCRIPTPATH
 * ~/.profile
 * ~/.bashrc
 * ~/.bash_profile
 * ~/.gitconfig
 * ~/.emacs
 * ~/.screenrc
 * ~/.config/

EOF

read -n 1 -p "Press 'p' to proceed or any other key to cancel: " proceedq
echo ""
echo ""
if [ "$proceedq" != "p" ]
then die "Aborting."
fi

[ -d "$HOME" ] || die "Bad home dir: $HOME"
[ -a "$HOME/.profile" ] && die "Existing ~/.profile found; aborting."
[ -a "$HOME/.profile" ] && die "Existing ~/.profile found; aborting."
[ -a "$HOME/.bashrc" ] && die "Existing ~/.bashrc found; aborting."
[ -a "$HOME/.bash_profile" ] && die "Existing ~/.bash_profile found; aborting."
[ -a "$HOME/.gitconfig" ] && die "Existing ~/.gitconfig found; aborting."
[ -a "$HOME/.emacs" ] && die "Existing ~/.emacs found; aborting."
[ -a "$HOME/.screenrc" ] && die "Existing ~/.screenrc found; aborting."

echo "Home directory appears clear."

# find relative path:
rp="$( python -c "import os.path; print(os.path.relpath('$SCRIPTPATH', '$HOME'))" )"
echo "Linking to relative path: $rp"
pushd "$HOME" &> /dev/null
ln -s "$rp" .config
ln -s ".config/_profile.sh" .profile
ln -s ".config/_bashrc.sh" .bashrc
ln -s ".config/_bash_profile.sh" .bash_profile
ln -s ".config/_gitconfig" .gitconfig
ln -s ".config/_emacs.el" .emacs
ln -s ".config/_screenrc" .screenrc
popd &> /dev/null

echo "Success!"

exit 0







