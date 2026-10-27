#!/bin/bash
# Turn every SRCDIR/<distro>/<arch>/ into a repository: createrepo_c, and sign repodata/repomd.xml with the
# package manager key (GPG_KEY_B64, protected with GPG_PASSPHRASE) when it is set.
#
# zypper refuses a repository with an unsigned repomd.xml, so the repo server must serve these repodata as is:
# running createrepo again there invalidates the signature.
#
# Usage: createrepo.sh SRCDIR
set -e

SRCDIR=${1:?usage: $0 SRCDIR}
TOPDIR=$(cd "$(dirname "$0")/.." && pwd)

if [ -n "${GPG_KEY_B64}" ]; then
	# shellcheck source=scripts/import_gpg_key.sh
	source "${TOPDIR}/scripts/import_gpg_key.sh"
	# the key the rpms are signed with
	GPG_NAME=$(awk '$1 == "%_gpg_name" { $1 = ""; print substr($0, 2) }' "${TOPDIR}/config/rpmmacros")
else
	echo "GPG_KEY_B64 is not set, repomd.xml will not be signed" >&2
fi

for DIR in "${SRCDIR}"/*/*/; do
	[ -d "${DIR}" ] || continue
	createrepo_c "${DIR}"
	[ -n "${GPG_KEY_B64}" ] || continue
	gpg --batch --yes --pinentry-mode loopback --local-user "${GPG_NAME}" \
		--detach-sign --armor "${DIR}repodata/repomd.xml"
	gpg --verify "${DIR}repodata/repomd.xml.asc" "${DIR}repodata/repomd.xml"
	# zypper offers to import this key when it is not trusted yet
	cp "${TOPDIR}/gpg_pubkey.asc" "${DIR}repodata/repomd.xml.key"
done
