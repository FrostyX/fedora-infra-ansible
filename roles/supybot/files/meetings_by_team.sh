#!/bin/bash

BASELOCATION=/srv/web/meetbot/teams
cd $BASELOCATION
cd ..

for f in `find -type f -mtime -30 | grep -v "fedora-meeting\."`
do
    teamname=$(basename $f | awk -F. '{ print $1 }' )
    mkdir -p $BASELOCATION/$teamname
    ln -s $PWD/$f $BASELOCATION/$teamname/ 2> /dev/null
done

