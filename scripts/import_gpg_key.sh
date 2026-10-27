# Import the package manager key (GPG_KEY_B64, protected with GPG_PASSPHRASE) in a throw-away keyring.
# Source this file: it exports GNUPGHOME and removes it again on exit.
#
# The passphrase is handed to gpg-agent through stdin, so it never ends up in a file or on a command line,
# and may contain any character.

if [ -z "${GPG_KEY_B64}" ]; then
	echo "GPG_KEY_B64 is not set, cannot sign" >&2
	exit 1
fi

# use a throw-away keyring, so the key does not end up in the keyring of the user running this
GNUPGHOME="$(mktemp -d)"
export GNUPGHOME
trap 'gpgconf --kill gpg-agent; rm -rf "${GNUPGHOME}"' EXIT
# allows the PRESET_PASSPHRASE below
echo allow-preset-passphrase >"${GNUPGHOME}/gpg-agent.conf"

# gpg_pubkey.asc has the current expiry date of the key, the secret key may still have an older one
echo "Importing pubkey..."
gpg --import --no-tty --batch --yes <"$(dirname "${BASH_SOURCE[0]}")/../gpg_pubkey.asc"
echo "Importing seckey..."
echo "${GPG_KEY_B64}" | base64 -d | gpg --import --no-tty --batch --yes

if [ -n "${GPG_PASSPHRASE}" ]; then
	echo "Caching passphrase in gpg-agent..."
	HEX_PASSPHRASE=$(printf '%s' "${GPG_PASSPHRASE}" | od -An -v -tx1 | tr -d ' \n')
	# the keyring only holds the package manager key
	RESULT=$(gpg --batch --with-colons --with-keygrip --list-secret-keys |
		awk -F: '$1 == "grp" { print $10 }' | while read -r KEYGRIP; do
		echo "PRESET_PASSPHRASE ${KEYGRIP} -1 ${HEX_PASSPHRASE}"
	done | gpg-connect-agent)
	if grep -q '^ERR' <<<"${RESULT}"; then
		echo "Caching the passphrase failed: ${RESULT}" >&2
		exit 1
	fi
fi
