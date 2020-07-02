#!/bin/bash

RSYNC_FLAGS='-avSHP --no-motd'

function syncHttpLogs {

    # in case we missed a run or two.. try to catch up the last 3 days.
    for d in 1 2 3
    do
        HOST=$1
	# some machines store stuff in old format. some new.
        if [ "$2" = "old" ]; then
            YESTERDAY=$(/bin/date -d "-$d days" +%Y-%m-%d)
        else
            YESTERDAY=$(/bin/date -d "-$d days" +%Y%m%d)
        fi
        YEAR=$(/bin/date -d "-$d days" +%Y)
        MONTH=$(/bin/date -d "-$d days" +%m)
        DAY=$(/bin/date -d "-$d days" +%d)
        /bin/mkdir -p /var/log/hosts/$HOST/$YEAR/$MONTH/$DAY/http
        cd /var/log/hosts/$HOST/$YEAR/$MONTH/$DAY/http/

        for f in $(/usr/bin/rsync $RSYNC_FLAGS --list-only $HOST::log/httpd/*$YESTERDAY* | awk '{ print $5 }')
        do
            DEST=$(echo $f | /bin/sed s/-$YESTERDAY//)
            /usr/bin/rsync $RSYNC_FLAGS $HOST::log/httpd/$f ./$DEST &> /dev/null
	    if [[ $? -ne 0 ]]; then
		echo "rsync from $HOST for file $f failed"
        done
    done
}

syncHttpLogs proxy01.iad2.fedoraproject.org
syncHttpLogs proxy02.vpn.fedoraproject.org
syncHttpLogs proxy03.vpn.fedoraproject.org
syncHttpLogs proxy04.vpn.fedoraproject.org
syncHttpLogs proxy05.vpn.fedoraproject.org
syncHttpLogs proxy06.vpn.fedoraproject.org
# syncHttpLogs proxy08.vpn.fedoraproject.org
syncHttpLogs proxy09.vpn.fedoraproject.org
syncHttpLogs proxy10.iad2.fedoraproject.org
syncHttpLogs proxy11.vpn.fedoraproject.org
syncHttpLogs proxy12.vpn.fedoraproject.org
syncHttpLogs proxy13.vpn.fedoraproject.org
syncHttpLogs proxy14.vpn.fedoraproject.org
syncHttpLogs proxy30.vpn.fedoraproject.org
syncHttpLogs proxy31.vpn.fedoraproject.org
syncHttpLogs proxy32.vpn.fedoraproject.org
syncHttpLogs proxy101.iad2.fedoraproject.org
syncHttpLogs proxy110.iad2.fedoraproject.org
# syncHttpLogs proxy01.stg.iad2.fedoraproject.org
 syncHttpLogs fedocal01.iad2.fedoraproject.org
 syncHttpLogs fedocal02.iad2.fedoraproject.org
# syncHttpLogs fedocal01.stg.iad2.fedoraproject.org
syncHttpLogs datagrepper01.iad2.fedoraproject.org
# syncHttpLogs datagrepper02.iad2.fedoraproject.org
# syncHttpLogs datagrepper01.stg.iad2.fedoraproject.org
# syncHttpLogs badges-web01.iad2.fedoraproject.org
# syncHttpLogs badges-web02.iad2.fedoraproject.org
# syncHttpLogs badges-web01.stg.iad2.fedoraproject.org
# syncHttpLogs packages03.iad2.fedoraproject.org
# syncHttpLogs packages04.iad2.fedoraproject.org
# syncHttpLogs packages03.stg.iad2.fedoraproject.org
syncHttpLogs blockerbugs01.iad2.fedoraproject.org
# syncHttpLogs blockerbugs02.iad2.fedoraproject.org
# syncHttpLogs blockerbugs01.stg.iad2.fedoraproject.org
syncHttpLogs value01.iad2.fedoraproject.org
syncHttpLogs people02.vpn.fedoraproject.org
syncHttpLogs noc01.iad2.fedoraproject.org
syncHttpLogs dl01.iad2.fedoraproject.org
syncHttpLogs dl02.iad2.fedoraproject.org
syncHttpLogs dl03.iad2.fedoraproject.org
syncHttpLogs dl04.iad2.fedoraproject.org
syncHttpLogs dl05.iad2.fedoraproject.org
syncHttpLogs download-rdu01.vpn.fedoraproject.org
syncHttpLogs download-ib01.vpn.fedoraproject.org
syncHttpLogs download-cc-rdu01.vpn.fedoraproject.org
syncHttpLogs sundries01.iad2.fedoraproject.org
# syncHttpLogs sundries02.iad2.fedoraproject.org
# syncHttpLogs sundries01.stg.iad2.fedoraproject.org
## eof
