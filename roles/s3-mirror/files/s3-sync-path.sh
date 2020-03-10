#!/usr/bin/env bash
# (c) 2019 Red Hat, Inc.
# LGPL
# Author: Rick Elrod <relrod@redhat.com>

if [[ "$1" == "" ]] || [[ $1 != /pub* ]] || [[ $1 != */ ]]; then
  echo "Syntax: $0 /pub/path/to/sync/"
  echo "NOTE! Path must end with a trailing /"
  exit 1
fi

# first run do not delete anything or copy the repodata.
CMD1="aws s3 sync                   \
  --exclude */repodata/*         \
  --exclude *.snapshot/*          \
  --exclude *source/*             \
  --exclude *SRPMS/*              \
  --exclude *debug/*              \
  --exclude *beta/*               \
  --exclude *ppc/*                \
  --exclude *ppc64/*              \
  --exclude *repoview/*           \
  --exclude *Fedora/*             \
  --exclude *EFI/*                \
  --exclude *core/*               \
  --exclude *extras/*             \
  --exclude *LiveOS/*             \
  --exclude *development/rawhide/* \
  --no-follow-symlinks            \
  --only-show-errors              \
  "
  #--dryrun                         \

# second we delete old content and also copy the repodata
CMD2="aws s3 sync                   \
  --delete                         \
  --exclude *.snapshot/*          \
  --exclude *source/*             \
  --exclude *SRPMS/*              \
  --exclude *debug/*              \
  --exclude *beta/*               \
  --exclude *ppc/*                \
  --exclude *ppc64/*              \
  --exclude *repoview/*           \
  --exclude *Fedora/*             \
  --exclude *EFI/*                \
  --exclude *core/*               \
  --exclude *extras/*             \
  --exclude *LiveOS/*             \
  --exclude *development/rawhide/* \
  --no-follow-symlinks            \
  --only-show-errors              \
  "
  #--dryrun                         \

#echo "$CMD /srv$1 s3://s3-mirror-us-west-1-02.fedoraproject.org$1"
echo "Starting $1 sync at $(date)" >> /var/log/s3-mirror/timestamps
$CMD1 /srv$1 s3://s3-mirror-us-west-1-02.fedoraproject.org$1
$CMD1 /srv$1/repodata/ s3://s3-mirror-us-west-1-02.fedoraproject.org$1/repodata/
# Always do the invalidations because they are quick and prevent issues
# depending on which path is synced.
for file in $(echo $1/repodata/* ); do
  aws cloudfront create-invalidation --distribution-id E2KJMDC0QAJDMU --paths "$file" > /dev/null
done
$CMD2 /srv$1 s3://s3-mirror-us-west-1-02.fedoraproject.org$1
echo "Ending $1 sync at $(date)" >> /var/log/s3-mirror/timestamps
