#!/bin/bash
set -e

cd "$(dirname "$0")"

function github_release_rpms {
	ORG=${2:-mannemsolutions}
	REPO=${1}
	URL="https://api.github.com/repos/${ORG}/${REPO}/releases/latest"
	curl -s "${URL}" | jq --raw-output '.assets[] | .browser_download_url'
}

function download_rpm {
	URL=$1
	BASENAME=$(basename "$URL")
	[ -e "$BASENAME" ] && return 0
	curl -OL "$URL"
}

cd /host/rpms

github_release_rpms wal-g-builder | while read -r RPM; do
	download_rpm "$RPM"
done
