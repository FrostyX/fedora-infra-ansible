#!/bin/bash

# Where do we keep our local/internal data?
LOCAL_DATA_DIR=/var/lib/countme
RAW_DB=$LOCAL_DATA_DIR/raw.db
TOTALS_DB=$LOCAL_DATA_DIR/totals.db
TOTALS_CSV=$LOCAL_DATA_DIR/totals.csv

# Where do we put the public-facing data?
PUBLIC_DATA_DIR=/var/www/html/csv-reports/countme
PUBLIC_TOTALS_DB=$PUBLIC_DATA_DIR/totals.db
PUBLIC_TOTALS_CSV=$PUBLIC_DATA_DIR/totals.csv

# Names of the update commands (if not in $PATH..)
UPDATE_RAWDB=countme-update-rawdb.sh
UPDATE_TOTALS=countme-update-totals.sh

# Copy with atomic overwrite
atomic_copy() {
    local src="$1" dst="$2"
    cp -f ${src} ${dst}.part
    mv -f ${dst}.part ${dst}
}

# die [MESSAGE]: prints "$PROG: error: $MESSAGE" on stderr and exits
die() { echo "${0##*/}: error: $*" >&2; exit 2; }

# _run [COMMAND...]: Run a command, honoring $VERBOSE and $DRYRUN
_run() {
    if [ "$VERBOSE" -o "$DRYRUN" ]; then echo "$@"; fi
    if [ "$DRYRUN" ]; then return 0; else "$@"; fi
}

# CLI help text
HELP_USAGE="usage: countme-updates.sh [OPTION]..."
HELP_OPTIONS="
Options:
  -h, --help           Show this message and exit
  -v, --verbose        Show more info about what's happening
  -n, --dryrun         Don't run anything, just show commands
  -p, --progress       Show progress meters while running
"

# Turn on progress by default if stderr is a tty
if [ -z "$PROGRESS" -a -t 2 ]; then PROGRESS=1; fi

# Parse CLI options with getopt(1)
_GETOPT_TMP=$(getopt \
    --name countme-update \
    --options hvnp \
    --longoptions help,verbose,dryrun,progress,checkoutdir: \
    -- "$@")
eval set -- "$_GETOPT_TMP"
unset _GETOPT_TMP
while [ $# -gt 0 ]; do
    arg=$1; shift
    case $arg in
        '-h'|'--help') echo "$HELP_USAGE"; echo "$HELP_OPTIONS"; exit 0 ;;
        '-v'|'--verbose') VERBOSE=1 ;;
        '-n'|'--dryrun') DRYRUN=1 ;;
        '-p'|'--progress') PROGRESS=1 ;;
        # Hidden option for testing / manual use
        '--checkoutdir') COUNTME_CHECKOUT=$1; shift ;;
        '--') break ;;
    esac
done

# Tweak path if needed
if [ -d "$COUNTME_CHECKOUT" ]; then
    cd $COUNTME_CHECKOUT
    PATH="$COUNTME_CHECKOUT:$COUNTME_CHECKOUT/scripts:$PATH"
fi

# Check for required commands
command -v $UPDATE_RAWDB  >/dev/null || die "can't find '$UPDATE_RAWDB'"
command -v $UPDATE_TOTALS >/dev/null || die "can't find '$UPDATE_TOTALS'"
command -v git            >/dev/null || die "can't find 'git'"

# Apply other CLI options
if [ "$PROGRESS" ]; then
    UPDATE_RAWDB="$UPDATE_RAWDB --progress"
    UPDATE_TOTALS="$UPDATE_TOTALS --progress"
fi

# Exit immediately on errors
set -e

# Run the updates
_run $UPDATE_RAWDB --rawdb $RAW_DB
_run $UPDATE_TOTALS --rawdb $RAW_DB --totals-db $TOTALS_DB --totals-csv $TOTALS_CSV

# Update local git repo
if [ ! -d $LOCAL_DATA_DIR/.git ]; then
    _run git init $LOCAL_DATA_DIR
    _run git -C $LOCAL_DATA_DIR add -N $(realpath $TOTALS_CSV --relative-to $LOCAL_DATA_DIR)
fi
_run git -C $LOCAL_DATA_DIR commit -a -m "$(date -u +%F) update"

# Copy new data into place
_run atomic_copy $TOTALS_DB $PUBLIC_TOTALS_DB
_run atomic_copy $TOTALS_CSV $PUBLIC_TOTALS_CSV
