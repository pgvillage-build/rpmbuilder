#!/bin/bash
# Print the builder images (as a JSON list) for every release of Fedora, Rocky Linux and openSUSE Leap that is
# released and not end of life according to https://endoflife.date, for amd64 and arm64.
#
# Usage: distro_releases.sh [--minimal]
#   --minimal  only the newest release of every distro, on one architecture (used for pull requests)
#
# Every entry has: baseimage and version (name artifacts and image tags), image (to build the builder image from),
# distro (short name of the release as in %{dist}, names release tarballs) and arch.
# A release without a container image (yet, e.g. on its release day) is skipped with a warning.
set -eo pipefail

TODAY=$(date +%F)
DOCKER=${DOCKER:-docker}

# <endoflife.date product> <baseimage> <image without tag> <distro prefix> <arch for --minimal>
DISTROS=(
	"fedora fedora docker.io/library/fedora fc amd64"
	"rocky-linux rockylinux docker.io/rockylinux/rockylinux el arm64"
	"opensuse opensuse-leap docker.io/opensuse/leap lp amd64"
)

for DISTRO in "${DISTROS[@]}"; do
	read -r PRODUCT BASEIMAGE IMAGE PREFIX MINIMAL_ARCH <<<"${DISTRO}"
	# newest first
	VERSIONS=$(curl -fsSL "https://endoflife.date/api/${PRODUCT}.json" |
		jq -r --arg today "${TODAY}" \
			'.[] | select(.releaseDate <= $today and (.eol == false or ((.eol | type) == "string" and .eol > $today))) | .cycle' |
		sort -rV)
	if [ "$1" = "--minimal" ]; then
		ARCHS=${MINIMAL_ARCH}
	else
		ARCHS="amd64 arm64"
	fi
	FOUND=false
	for VERSION in ${VERSIONS}; do
		if ! ${DOCKER} manifest inspect "${IMAGE}:${VERSION}" >/dev/null 2>&1; then
			echo "::warning::${PRODUCT} ${VERSION} is released, but there is no image ${IMAGE}:${VERSION} (yet)" >&2
			continue
		fi
		FOUND=true
		for ARCH in ${ARCHS}; do
			jq -nc --arg baseimage "${BASEIMAGE}" --arg version "${VERSION}" --arg image "${IMAGE}:${VERSION}" \
				--arg distro "${PREFIX}${VERSION//./}" --arg arch "${ARCH}" \
				'{baseimage: $baseimage, version: $version, image: $image, distro: $distro, arch: $arch}'
		done
		[ "$1" = "--minimal" ] && break
	done
	if [ "${FOUND}" = false ]; then
		echo "No supported release of ${PRODUCT} with an image" >&2
		exit 1
	fi
done | jq -sc .
