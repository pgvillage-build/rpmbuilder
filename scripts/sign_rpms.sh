#!/bin/bash
# Sign the rpms in RPMDEST with the package manager key (GPG_KEY_B64, protected with GPG_PASSPHRASE).
set -e

DEST=${DEST:-/host}
cd "$DEST"
export RPMDEST=${RPMDEST:-${DEST}/rpms}

cp config/rpmmacros ~/.rpmmacros
# shellcheck source=scripts/import_gpg_key.sh
source "${DEST}/scripts/import_gpg_key.sh"

echo "rpmsign --addsign..."
rpmsign --addsign "${RPMDEST}"/*.rpm

echo Signing finished succesfully
