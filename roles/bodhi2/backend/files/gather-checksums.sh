#!/usr/bin/env bash

# This just gathers a directory of image and iso checksums for the websites
# team.

set -eux

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 [test/NN | NN] /path/to/outdir"
  echo "Example: $0 test/33 /root/f33beta-checksums"
  echo "Example: $0 32 /root/f32-checksums"
  exit 1
fi

# Quick paranoia check so that we don't try to write to /pub ever.
if [[ "$2" = '/pub'* ]]; then
  echo "Refusing to run with second argument starting with /pub"
  exit 1
fi

echo "Creating $2/{iso,images}"
mkdir -p "$2/images" "$2/iso"

echo "Copying checksums from /pub/fedora/linux/releases/$1"
for file in `find "/pub/fedora/linux/releases/$1" -name *-CHECKSUM | grep images`; do cp "$file" "$2/images/"; done
for file in `find "/pub/fedora/linux/releases/$1" -name *-CHECKSUM | grep iso`; do cp "$file" "$2/iso/"; done

echo "Copying checksums from /pub/fedora-secondary/releases/$1"
for file in `find "/pub/fedora-secondary/releases/$1" -name *-CHECKSUM | grep images`; do cp "$file" "$2/images/"; done
for file in `find "/pub/fedora-secondary/releases/$1" -name *-CHECKSUM | grep iso`; do cp "$file" "$2/iso/"; done

echo "Copying checksums from /pub/alt/releases/$1"
for file in `find "/pub/alt/releases/$1" -name *-CHECKSUM | grep images`; do cp "$file" "$2/images/"; done
for file in `find "/pub/alt/releases/$1" -name *-CHECKSUM | grep iso`; do cp "$file" "$2/iso/"; done

echo "Checksum files have been copied to $2, please hand this directory to the websites team."
