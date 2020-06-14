#!/bin/bash

cd /srv/web/meetbot/teams || exit
for team in *; do
    pushd "$team" >/dev/null 2>&1 || { echo "Refusing to process non-directory: /srv/web/meetbot/teams/$team"; continue; }
    tar -cphf "/srv/web/meetbot/archives/$team.tgz" ./*.log.txt
    popd >/dev/null 2>&1 || { echo "Something really weird happened and popd failed. Aborting."; continue; }
done
