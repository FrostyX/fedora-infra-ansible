#!/bin/bash -x
ADMIN_PASSWORD="$1"

function cleanup {
    kdestroy -A
}
trap cleanup EXIT

echo $ADMIN_PASSWORD | kinit admin

# Disable default permissions so we don't break our privacy policy
ipa permission-mod "System: Read User Addressbook Attributes" --bindtype=permission
