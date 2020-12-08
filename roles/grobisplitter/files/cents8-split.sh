#!/bin/bash

## Setup basic environment variables.
HOMEDIR=/mnt/fedora/app/fi-repo/centos/centos-8-stream
BINDIR=/usr/local/bin

ARCHES="aarch64 ppc64le x86_64"
DATE=$(date -Ih | sed 's/+.*//')

KOJIDIR=/mnt/fedora/app/fi-repo/centos/stream8-kojitarget
DATEDIR=${KOJIDIR}/${DATE}

##
## Make a directory for where the new tree will live. Use a new date
## so that we can roll back to an older release or stop updates for
## some time if needed. 
if [ -d ${DATEDIR} ]; then
    echo "Directory already exists. Please remove or fix"
    exit
else
mkdir -p ${DATEDIR}
fi

##
## Go through each architecture and split out the trees. This is done
## differently than RHEL because we don't use reposync to get the files
## 
for ARCH in ${ARCHES}; do
    # The archdir is where we daily download updates for rhel8

    # We consolidate all of the default repositories and remerge them
    # in a daily tree. This allows us to point koji at a particular
    # day if we have specific build concerns.
    OUTDIR=${DATEDIR}/${ARCH}
    mkdir -p ${OUTDIR}
    if [ ! -d ${OUTDIR} ]; then
	echo "Unable to find ${ARCHDIR}"
	exit
    else
	cd ${OUTDIR}
    fi

    # Begin splitting the various packages into their subtrees
    ${BINDIR}/splitter.py --action hardlink --target CS-8-001 ${HOMEDIR}/BaseOS/${ARCH}/os/ --only-defaults &> /dev/null
    if [ $? -ne 0 ]; then
	echo "splitter ${ARCH} baseos failed"
	exit
    fi
    ${BINDIR}/splitter.py --action hardlink --target CS-8-002 ${HOMEDIR}/AppStream/${ARCH}/os/ --only-defaults &> /dev/null
    if [ $? -ne 0 ]; then
	echo "splitter ${ARCH} appstream failed"
	exit
    fi
    ${BINDIR}/splitter.py --action hardlink --target CS-8-003 ${HOMEDIR}/PowerTools/${ARCH}/os/ &> /dev/null
    if [ $? -ne 0 ]; then
	echo "splitter ${ARCH} codeready failed"
	exit
    fi

    # Copy the various module trees into CS-8-001 where we want them
    # to work.
    echo "Moving data to ${ARCH}/CS-8-001"
    cp -anlr CS-8-002/* CS-8-001
    cp -anlr CS-8-003/* CS-8-001
    # Go into the main tree
    pushd CS-8-001

    # Mergerepo didn't work so lets just createrepo in the top directory.
    createrepo_c .  &> /dev/null
    popd

    # Cleanup the trash 
    rm -rf CS-8-002 CS-8-003
#loop to the next
done

## Set up the builds so they are pointing to the last working version
cd ${KOJIDIR}
if [[ -e staged ]]; then
    if [[ -h staged ]]; then
	rm -f staged
    else
	echo "Unable to remove staged. it is not a symbolic link"
	exit
    fi
else
    echo "No staged link found"
fi

echo "Linking ${DATE} to staged"
ln -s ${DATE} staged


for ARCH in ${ARCHES}; do
    if [[ -d latest/ ]]; then
	pushd latest/
    else
	mkdir latest/
	pushd latest/
    fi
    mkdir -p ${ARCH}
    dnf --disablerepo=\* --enablerepo=CS-8-001 --repofrompath=CS-8-001,https://infrastructure.fedoraproject.org/repo/centos/stream8-kojitarget/staged/${ARCH}/CS-8-001/ reposync -a ${ARCH} -a noarch -p ${ARCH} --newest --delete  &> /dev/null
    if [[ $? -eq 0 ]]; then
	cd ${ARCH}/CS-8-001
	createrepo_c .  &> /dev/null
    else
	echo "Unable to run createrepo on latest/${ARCH}"
    fi
    popd
done
