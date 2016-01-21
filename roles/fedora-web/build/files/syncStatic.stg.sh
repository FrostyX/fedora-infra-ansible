#!/bin/bash
# mmcgrath@redhat.com 09-20-2007
#

function build {
    site="$1"
    err=$(
        {
            cd "$site" && \
            make syncpos && \
            make && \
            rsync -qa --delete-after --delay-updates out/ "/srv/web/$site/"; \
        } 2>&1
    )

    rc=$?
    if [ $rc -ne 0 ]; then
        echo "$site build failed"
        echo "===================================="
        echo "$err"
        echo
    fi

    return $rc;
}

if [ ! -d  /srv/web/fedora-web/.git ]
then
    /usr/bin/git clone -q \
        git://git.fedorahosted.org/fedora-web.git \
        /srv/web/fedora-web
fi

# Freeze the website to prepare beta changes.  On release day, comment the git
# checkout line below, run this script, and use:
# sudo func proxy\* call command run "/usr/bin/rsync -a --no-owner --no-group sundries01::fedoraproject.org/* /srv/web/fedoraproject.org/"
# on puppet1 to update the website.
#
# For any other last-minute changes or fixes, make the necessary changes in the
# fedora-web repo, then run this script and the above func command.
#
# Good luck!

cd /srv/web/fedora-web

/usr/bin/git clean -q -fdx || exit 1
/usr/bin/git reset -q --hard || exit 1
/usr/bin/git checkout -q two-week-atomic || exit 1

/usr/bin/git pull -q --ff-only || exit 1
build spins.fedoraproject.org
build labs.fedoraproject.org
build arm.fedoraproject.org
build getfedora.org
build flocktofedora.org

pushd mirrors.fedoraproject.org > /dev/null
rsync -qa --delete-after --delay-updates . /srv/web/mirrors.fedoraproject.org/
popd > /dev/null

# Make sure everything else builds from master.
/usr/bin/git clean -q -fdx || exit 1
/usr/bin/git reset -q --hard || exit 1
/usr/bin/git checkout -q master || exit 1

/usr/bin/git pull -q --ff-only || exit 1

build boot.fedoraproject.org
build fedoracommunity.org
build fudcon.fedoraproject.org
build start.fedoraproject.org
