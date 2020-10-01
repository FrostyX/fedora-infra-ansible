#!/bin/bash
set -e

cd /srv/badges_checkout/
git pull >/dev/null 2>&1
for i in pngs stls ; do
    rsync --delete -ar /srv/badges_checkout/$i/ /usr/share/badges/$i/
done
