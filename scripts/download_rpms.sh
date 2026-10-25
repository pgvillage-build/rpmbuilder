#!/bin/bash
#
# Download the rpms attached to the releases listed in config/prebuilt-rpms.txt into RPMDEST.
set -e

[ -e /host ] && DEST=/host || DEST="$(cd "$(dirname "$0")/.." && pwd)"
RPMDEST=${RPMDEST:-${DEST}/rpms}
PREBUILT=${PREBUILT:-${DEST}/config/prebuilt-rpms.txt}

mkdir -p "${RPMDEST}"
cd "${RPMDEST}"
grep -vE '^\s*(#|$)' "${PREBUILT}" | while read -r REPO PACKAGE TAG; do
	echo "Downloading the ${PACKAGE} rpms of ${REPO} ${TAG}"
	curl -fsSL --retry 3 "https://api.github.com/repos/${REPO}/releases/tags/${TAG}" |
		jq -r '.assets[] | select(.name | endswith(".rpm")) | .browser_download_url' |
		while read -r URL; do
			[ -e "$(basename "${URL}")" ] && continue
			curl -fsSL --retry 3 -O "${URL}"
		done
done

ls ./*.rpm
