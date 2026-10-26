#!/bin/bash
# Print a GitHub Actions matrix (as `mymatrix=<json>`) that builds every spec in ./specs on every builder image in
# BUILDERS for its architecture.
#
# Usage: BUILDERS="$(scripts/distro_releases.sh)" speclist_as_json.sh
set -eo pipefail

: "${BUILDERS:?set BUILDERS to the output of distro_releases.sh}"

for SPEC in specs/*; do
	[ -f "${SPEC}" ] || continue
	case "${SPEC}" in
		*x86_64*) ARCH=amd64 ;;
		*aarch64*) ARCH=arm64 ;;
		*) continue ;;
	esac
	jq -c --arg arch "${ARCH}" --arg spec "$(basename "${SPEC}")" \
		'.[] | select(.arch == $arch) | {arch, baseimage, version, distro, spec: $spec}' <<<"${BUILDERS}"
done | jq -rsc '"mymatrix=" + ({include: .} | tojson)'
