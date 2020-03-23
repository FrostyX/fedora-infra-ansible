#!/usr/bin/env bash
# (c) 2018 Red Hat, Inc.
# LGPL
# Author: Rick Elrod <relrod@redhat.com>

aws_sync=( aws s3 sync --no-follow-symlinks )

excludes=(
  --exclude "*/.snapshot/*"
  --exclude "*/source/*"
  --exclude "*/SRPMS/*"
  --exclude "*/debug/*"
  --exclude "*/beta/*"
  --exclude "*/ppc/*"
  --exclude "*/ppc64/*"
  --exclude "*/repoview/*"
  --exclude "*/Fedora/*"
  --exclude "*/EFI/*"
  --exclude "*/core/*"
  --exclude "*/extras/*"
  --exclude "*/LiveOS/*"
  --exclude "*/development/rawhide/*"
  --exclude "*/releases/8/*"
  --exclude "*/releases/9/*"
  --exclude "*/releases/10/*"
  --exclude "*/releases/11/*"
  --exclude "*/releases/12/*"
  --exclude "*/releases/13/*"
  --exclude "*/releases/14/*"
  --exclude "*/releases/15/*"
  --exclude "*/releases/16/*"
  --exclude "*/releases/17/*"
  --exclude "*/releases/18/*"
  --exclude "*/releases/19/*"
  --exclude "*/releases/20/*"
  --exclude "*/releases/21/*"
  --exclude "*/releases/22/*"
  --exclude "*/releases/23/*"
  --exclude "*/releases/24/*"
  --exclude "*/releases/25/*"
  --exclude "*/releases/26/*"
  --exclude "*/releases/27/*"
  --exclude "*/releases/28/*"
  --exclude "*/releases/29/*"
  --exclude "*/updates/8/*"
  --exclude "*/updates/9/*"
  --exclude "*/updates/10/*"
  --exclude "*/updates/11/*"
  --exclude "*/updates/12/*"
  --exclude "*/updates/13/*"
  --exclude "*/updates/14/*"
  --exclude "*/updates/15/*"
  --exclude "*/updates/16/*"
  --exclude "*/updates/17/*"
  --exclude "*/updates/18/*"
  --exclude "*/updates/19/*"
  --exclude "*/updates/20/*"
  --exclude "*/updates/21/*"
  --exclude "*/updates/22/*"
  --exclude "*/updates/23/*"
  --exclude "*/updates/24/*"
  --exclude "*/updates/25/*"
  --exclude "*/updates/26/*"
  --exclude "*/updates/27/*"
  --exclude "*/updates/28/*"
  --exclude "*/updates/29/*"
  --exclude "*/updates/testing/8/*"
  --exclude "*/updates/testing/9/*"
  --exclude "*/updates/testing/10/*"
  --exclude "*/updates/testing/11/*"
  --exclude "*/updates/testing/12/*"
  --exclude "*/updates/testing/13/*"
  --exclude "*/updates/testing/14/*"
  --exclude "*/updates/testing/15/*"
  --exclude "*/updates/testing/16/*"
  --exclude "*/updates/testing/17/*"
  --exclude "*/updates/testing/18/*"
  --exclude "*/updates/testing/19/*"
  --exclude "*/updates/testing/20/*"
  --exclude "*/updates/testing/21/*"
  --exclude "*/updates/testing/22/*"
  --exclude "*/updates/testing/23/*"
  --exclude "*/updates/testing/24/*"
  --exclude "*/updates/testing/25/*"
  --exclude "*/updates/testing/26/*"
  --exclude "*/updates/testing/27/*"
  --exclude "*/updates/testing/28/*"
  --exclude "*/updates/testing/29/*"
)

# First run this command that syncs, but does not delete.
# It also excludes repomd.xml.
CMD1=( "${aws_sync[@]}" "${excludes[@]}" --exclude "*/repomd.xml" )

# Next we run this command which syncs repomd.xml files.  Include must precede
# the large set of excludes.  Make sure that the 'max-age' isn't too large so
# we know that we can start removing old data ASAP.
CMD2=( "${aws_sync[@]}" --exclude "*" --include "*/repomd.xml" "${excludes[@]}" --cache-control max-age=300 )

# Then we delete old RPMs and old metadata (but after invalidating caches).
CMD3=( "${aws_sync[@]}" "${excludes[@]}" --delete )

S3_MIRROR=s3-mirror-us-west-1-02.fedoraproject.org
DIST_ID=E2KJMDC0QAJDMU

# Sync EPEL
#echo $CMD /srv/pub/epel/ s3://$S3_MIRROR/pub/epel/
echo "Starting EPEL sync at $(date)" >> /var/log/s3-mirror/timestamps
"${CMD1[@]}" /srv/pub/epel/ "s3://$S3_MIRROR/pub/epel/"
"${CMD2[@]}" /srv/pub/epel/ "s3://$S3_MIRROR/pub/epel/"
echo "Ending EPEL sync at $(date)" >> /var/log/s3-mirror/timestamps
for file in $(echo /srv/pub/epel/6/*/repodata/repomd.xml | sed 's#/srv##g'); do
  aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "$file"
done

for file in $(echo /srv/pub/epel/7/*/repodata/repomd.xml | sed 's#/srv##g'); do
  aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "$file"
done

for file in $(echo /srv/pub/epel/8/*/repodata/repomd.xml | sed 's#/srv##g'); do
  aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "$file"
done

# Sync Fedora
#echo $CMD /srv/pub/fedora/ s3://$S3_MIRROR/pub/fedora/
echo "Starting Fedora sync at $(date)" >> /var/log/s3-mirror/timestamps
"${CMD1[@]}" /srv/pub/fedora/ "s3://$S3_MIRROR/pub/fedora/"
"${CMD2[@]}" /srv/pub/fedora/ "s3://$S3_MIRROR/pub/fedora/"
echo "Ending Fedora sync at $(date)" >> /var/log/s3-mirror/timestamps

for file in $(echo /srv/pub/fedora/linux/updates/*/*/*/repodata/repomd.xml | sed 's#/srv##g'); do
  aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "$file"
done

# Consider some DNF processes started downloading metadata before we invalidated
# caches, and started with outdated repomd.xml file.  Give it 10 minutes so they
# have chance to download the rest of metadata and RPMs.
sleep 600

"${CMD3[@]}" /srv/pub/epel/ "s3://$S3_MIRROR/pub/epel/"
"${CMD3[@]}" /srv/pub/fedora/ s3://$S3_MIRROR/pub/fedora/
