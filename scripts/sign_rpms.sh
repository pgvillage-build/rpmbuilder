#!/bin/bash
# Sign the rpms in RPMDEST with the package manager key (GPG_KEY_B64, protected with GPG_PASSPHRASE).
#
# The key is imported in a throw-away keyring and its passphrase is handed to gpg-agent through stdin,
# so the passphrase never ends up in a file or on a command line, and may contain any character.
set -e

DEST=${DEST:-/host}
cd "$DEST"
export RPMDEST=${RPMDEST:-${DEST}/rpms}

if [ -z "${GPG_KEY_B64}" ]; then
	echo "GPG_KEY_B64 is not set, cannot sign the rpms" >&2
	exit 1
fi

cp config/rpmmacros ~/.rpmmacros
GPG_NAME=$(rpm --eval '%{_gpg_name}')

# use a throw-away keyring, so the key does not end up in the keyring of the user running this
GNUPGHOME="$(mktemp -d)"
export GNUPGHOME
trap 'gpgconf --kill gpg-agent; rm -rf "${GNUPGHOME}"' EXIT
# allows the PRESET_PASSPHRASE below
echo allow-preset-passphrase >"${GNUPGHOME}/gpg-agent.conf"

echo "Importing pubkey..."
gpg --import --no-tty --batch --yes <gpg_pubkey.asc
echo "Importing seckey..."
echo "${GPG_KEY_B64}" | base64 -d | gpg --import --no-tty --batch --yes

if [ -n "${GPG_PASSPHRASE}" ]; then
	echo "Caching passphrase in gpg-agent..."
	HEX_PASSPHRASE=$(printf '%s' "${GPG_PASSPHRASE}" | od -An -v -tx1 | tr -d ' \n')
	RESULT=$(gpg --batch --with-colons --with-keygrip --list-secret-keys "${GPG_NAME}" |
		awk -F: '$1 == "grp" { print $10 }' | while read -r KEYGRIP; do
		echo "PRESET_PASSPHRASE ${KEYGRIP} -1 ${HEX_PASSPHRASE}"
	done | gpg-connect-agent)
	if grep -q '^ERR' <<<"${RESULT}"; then
		echo "Caching the passphrase failed: ${RESULT}" >&2
		exit 1
	fi
fi

echo "rpmsign --addsign..."
rpmsign --addsign "${RPMDEST}"/*.rpm

echo Signing finished succesfully
