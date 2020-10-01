#!/bin/bash
set -e

cd /srv/badges_checkout/
git pull
( rsync --delete -ar --itemize-changes /srv/badges_checkout/rules/ /usr/share/badges/rules/ | grep -q '^>f' ) && service fedmsg-hub restart
