#!/usr/bin/env bash



echo "### Starting ###"
echo "Begin to config"
folders=(bash vim tmux git)
for f in ${folders[@]};
do
  stow -v -R $f -t ~/
done
echo "### Ending ###"


