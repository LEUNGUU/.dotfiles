#!/usr/bin/env bash


## backup bashpofile

[ -f ~/.bashrc ] && mv -v ~/.bashrc bashrc.old
[ -f ~/.bash_profile ] && mv -v ~/.bash_profile bash_profile.old
[ -f ~/.bash_aliases ] && mv -v ~/.bash_aliases bash_aliases.old
[ -f ~/.bash_logout ] && mv -v ~/.bash_logout bash_logout.old

function setup() {
    echo "### Starting ###"
    echo "Begin to config"
    echo -e "do you really want to install all items? [y/n]: "
    read  ans
	  if [ $ans'x' == 'yx' ];then
      echo "Going to install all item(bash,vim,tmux,git)..."
	  else
	    echo "You can set INSTALL_ONLY environment variable to specify what you need."
	    exit
	  fi
    if [[ "${INSTALL_ONLY}" == "" ]]; then
      folders=(bash vim tmux git)
    else
      folders=${INSTALL_ONLY}
    fi
    for f in "${folders[@]}";
    do
      stow -v -R "$f" -t ~/
    done
    echo "### Ending ###"
}

setup
