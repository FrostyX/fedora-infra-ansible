#!/bin/bash

# This file is part of Fedora Project Infrastructure Ansible
# Repository.
#
# Fedora Project Infrastructure Ansible Repository is free software:
# you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later
# version.
#
# Fedora Project Infrastructure Ansible Repository is distributed in
# the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with Fedora Project Infrastructure Ansible Repository.  If
# not, see <http://www.gnu.org/licenses/>.

# Some constants / standard paths
LOGDIR=/var/log/hosts
NFSDIR=/mnt/fedora_stats/combined-http
LOGMERGE=/usr/share/awstats/tools/logresolvemerge.pl

# Because sync-http may not get all logs immediately, we look back
# a couple days to find the "latest" logs to merge.
LATEST_LOG_DATE="2 days ago"

# Funtion to parse a DATE_STR and print YYYY/MM/DD
ymd() { date -d "$*" +%Y/%m/%d; }

# Get YYYY/MM/DD for LATEST_LOG_DATE, for later use
LATEST_YMD=$(ymd $LATEST_LOG_DATE)

# Prints usage. Also serves as docs for anyone reading the source (hi there!)
usage() {
cat <<__USAGE__
usage: $0 [DATE_STR]
combine daily logs from $LOGDIR to $NFSDIR.

Default date is '$LATEST_LOG_DATE' (currently $LATEST_YMD).
DATE_STR may be any date older than that, in any format understood by date(1):
  "June 9"
  "2020-06-23 -2weeks"
__USAGE__
}

# Check CLI args to set LOG_DATE
case $# in
    0) LOG_DATE="$LATEST_LOG_DATE"; UPDATE_LATEST=1 ;;
    1) [ "$1" == "-h" -o "$1" == "--help" ] && usage && exit 0
       LOG_DATE="$1" ;;
    *) usage; exit 2 ;;
esac

# Parse LOG_DATE
YMD=$(ymd $LOG_DATE) || exit 2

# Safety check for dates that are too new for us to handle.
# (Also catches weird "dates" that date(1) allows, like '' or '0' or 'wet')
if [[ "$YMD" > "$LATEST_YMD" ]]; then
    echo "$0: error: DATE_STR '$LOG_DATE' ($YMD) newer than LATEST_LOG_DATE ($LATEST_YMD)" >&2
    exit 3
fi

# Okay we're good. Set paths, make directories, and do some merging!
PROXYLOG=${LOGDIR}/proxy*/${YMD}/http/
DL_LOG=${LOGDIR}/dl*/${YMD}/http/
PEOPLE=${LOGDIR}/people*/${YMD}/http/

TARGET=${NFSDIR}/${YMD}
mkdir -p ${TARGET}

##
## Merge the Proxies
FILES=$( ls -1 ${PROXYLOG}/*access.log.xz | awk '{x=split($0,a,"/"); print a[x]}' | sort -u )

for FILE in ${FILES}; do
    TEMP=$(echo ${FILE} | sed 's/\.xz$//')
    perl ${LOGMERGE} ${PROXYLOG}/${FILE} > ${TARGET}/${TEMP}
done

##
## Merge the Downloads
FILES=$( ls -1 ${DL_LOG}/dl*access.log.xz | awk '{x=split($0,a,"/"); print a[x]}' | sort -u )

for FILE in ${FILES}; do
    TEMP=$(echo ${FILE} | sed 's/\.xz$//')
    perl ${LOGMERGE} ${DL_LOG}/${FILE} > ${TARGET}/${TEMP}
done

##
## Merge the People
##
## Merge the Downloads
FILES=$( ls -1 ${PEOPLE}/fedora*access.log.xz | awk '{x=split($0,a,"/"); print a[x]}' | sort -u )

for FILE in ${FILES}; do
    TEMP=$(echo ${FILE} | sed 's/\.xz$//')
    perl ${LOGMERGE} ${PEOPLE}/${FILE} > ${TARGET}/${TEMP}
done

# Now we link up the files into latest directory
# 1. make sure the latest directory exists
# 2. go into it.
# 3. remove the old links
# 4. link up all the files we merged over

if [[ "$UPDATE_LATEST" && -d ${NFSDIR}/latest ]]; then
    pushd ${NFSDIR}/latest &> /dev/null
    /bin/rm -f *
    for file in ../${YMD}/*; do
	ln -s ${file} .
    done
    popd &> /dev/null
fi
