#!/bin/bash -x
ADMIN_PASSWORD="$1"

function cleanup {
    kdestroy -A
}
trap cleanup EXIT

echo $ADMIN_PASSWORD | kinit admin

# Disable default permissions so we don't break our privacy policy
ipa permission-mod "System: Read User Addressbook Attributes" --bindtype=permission

# Allow users to read their own data (needed because of the previous line)
ipa selfservice-find "Users can read their own addressbook attributes" --pkey-only || \
ipa selfservice-add "Users can read their own addressbook attributes" \
    --permissions read \
    --attrs mail --attrs userCertificate --attrs ipaCertmapData
