#!/bin/bash
set -e

cd /srv/badges_checkout/
git pull
( rsync --delete -ar --itemize-changes /srv/badges_checkout/rules/ /srv/web/infra/badges/rules/ | grep -q '^>f' ) && service fedmsg-hub restart
