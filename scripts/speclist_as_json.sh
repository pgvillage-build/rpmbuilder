#!/bin/bash
# Print a GitHub Actions matrix (as `mymatrix=<json>`) that builds every spec in ./specs on every base image
# for its architecture.
#
# Usage: speclist_as_json.sh [--minimal]
#   --minimal  build on a few base images only (used for pull requests)
set -e

if [ "$1" = "--minimal" ]; then
	AMD64_IMAGES=(fedora:44 opensuse-leap:16.0)
	ARM64_IMAGES=(rockylinux:10)
else
	AMD64_IMAGES=(fedora:{43..44} rockylinux:{8..10} opensuse-leap:16.0)
	ARM64_IMAGES=("${AMD64_IMAGES[@]}")
fi

for SPEC in specs/*; do
	[ -f "${SPEC}" ] || continue
	case "${SPEC}" in
		*x86_64*) ARCH=amd64; IMAGES=("${AMD64_IMAGES[@]}") ;;
		*aarch64*) ARCH=arm64; IMAGES=("${ARM64_IMAGES[@]}") ;;
		*) continue ;;
	esac
	for IMAGE in "${IMAGES[@]}"; do
		# short name of the distro release (as in %{dist}), used to name artifacts and release tarballs
		case "${IMAGE%%:*}" in
			rockylinux) DISTRO="el${IMAGE#*:}" ;;
			fedora) DISTRO="fc${IMAGE#*:}" ;;
			opensuse-leap) DISTRO="lp${IMAGE#*:}"; DISTRO="${DISTRO//./}" ;;
			*) echo "no distro name for ${IMAGE}" >&2; exit 1 ;;
		esac
		jq -nc --arg arch "${ARCH}" --arg baseimage "${IMAGE%%:*}" --arg version "${IMAGE#*:}" \
			--arg distro "${DISTRO}" --arg spec "$(basename "${SPEC}")" \
			'{arch: $arch, baseimage: $baseimage, version: $version, distro: $distro, spec: $spec}'
	done
done | jq -rsc '"mymatrix=" + ({include: .} | tojson)'
