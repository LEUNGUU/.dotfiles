#!/usr/bin/env bash


## backup bashpofile
[ -f .bashrc ] && mv -v .bashrc bashrc.old
[ -f .bash_profile ] && mv -v .bash_profile bash_profile.old
[ -f .bash_aliases ] && mv -v .bash_aliases bash_aliases.old
[ -f .bash_logout ] && mv -v .bash_logout bash_logout.old

echo "### Starting ###"
echo "Begin to config"
folders=(bash vim tmux git)
for f in "${folders[@]}";
do
  stow -v -R "$f" -t ~/
done
echo "### Ending ###"


