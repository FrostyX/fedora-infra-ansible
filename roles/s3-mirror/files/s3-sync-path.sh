#!/usr/bin/env bash
# (c) 2019 Red Hat, Inc.
# LGPL
# Author: Rick Elrod <relrod@redhat.com>

if [[ "$1" == "" ]] || [[ $1 != /pub* ]] || [[ $1 != */ ]]; then
  echo "Syntax: $0 /pub/path/to/sync/"
  echo "NOTE! Path must end with a trailing /"
  exit 1
fi

aws_sync=( aws s3 sync --no-follow-symlinks )

# first run do not delete anything or copy the repodata.
exclude=(
  --exclude "*.snapshot/*"
  --exclude "*source/*"
  --exclude "*SRPMS/*"
  --exclude "*debug/*"
  --exclude "*beta/*"
  --exclude "*ppc/*"
  --exclude "*ppc64/*"
  --exclude "*repoview/*"
  --exclude "*Fedora/*"
  --exclude "*EFI/*"
  --exclude "*core/*"
  --exclude "*extras/*"
  --exclude "*LiveOS/*"
  --exclude "*development/rawhide/*"
  --only-show-errors
)

S3_MIRROR=s3-mirror-us-west-1-02.fedoraproject.org
DIST_ID=E2KJMDC0QAJDMU
MAX_CACHE_SEC=60
DNF_GENTLY_TIMEOUT=120

# First run this command that syncs, but does not delete.
# It also excludes repomd.xml.
CMD1=( "${aws_sync[@]}" "${excludes[@]}" --exclude "*/repomd.xml" )

# Next we run this command which syncs repomd.xml files.  Include must precede
# the large set of excludes.  Make sure that the 'max-age' isn't too large so
# we know that we can start removing old data ASAP.
CMD2=( "${aws_sync[@]}" --exclude "*" --include "*/repomd.xml" "${excludes[@]}"
                        --cache-control "max-age=$MAX_CACHE_SEC" )

# Then we delete old RPMs and old metadata (but after invalidating caches).
CMD3=( "${aws_sync[@]}" "${excludes[@]}" --delete )

#echo "$CMD /srv$1 s3://s3-mirror-us-west-1-02.fedoraproject.org$1"
echo "Starting $1 sync at $(date)" >> /var/log/s3-mirror/timestamps
"${CMD1[@]}" "/srv$1" "s3://$S3_MIRROR$1"
"${CMD2[@]}" "/srv$1" "s3://$S3_MIRROR$1"

# Always do the invalidations because they are quick and prevent issues
# depending on which path is synced.
for file in $(echo $1/repodata/repomd.xml ); do
  aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "$file" > /dev/null
done

SLEEP=$(( MAX_CACHE_SEC + DNF_GENTLY_TIMEOUT ))
echo "Ready $1 sync, giving dnf downloads ${SLEEP}s before delete, at $(date)" >> /var/log/s3-mirror/timestamps

# Consider some DNF processes started downloading metadata before we invalidated
# caches, and started with outdated repomd.xml file.  Give it few more seconds
# so they have chance to download the rest of metadata and RPMs.
sleep $SLEEP

"${CMD3[@]}" "/srv$1" "s3://$S3_MIRROR$1"

echo "Ending $1 sync at $(date)" >> /var/log/s3-mirror/timestamps
