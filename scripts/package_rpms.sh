#!/bin/bash
# Pack the rpms in SRCDIR/<distro>/<arch>/ into one tarball per distro release, and write a SHA256SUMS for them.
#
# Usage: package_rpms.sh SRCDIR VERSION DESTDIR
#   creates DESTDIR/pgvillage-rpms-VERSION-<distro>.tar.gz, which unpacks to pgvillage-rpms-VERSION-<distro>/<arch>/
set -e

SRCDIR=${1:?usage: $0 SRCDIR VERSION DESTDIR}
VERSION=${2:?usage: $0 SRCDIR VERSION DESTDIR}
DESTDIR=${3:?usage: $0 SRCDIR VERSION DESTDIR}

mkdir -p "${DESTDIR}"
for DIR in "${SRCDIR}"/*/; do
	[ -d "${DIR}" ] || continue
	DISTRO=$(basename "${DIR}")
	NAME="pgvillage-rpms-${VERSION}-${DISTRO}"
	tar -C "${SRCDIR}" -czf "${DESTDIR}/${NAME}.tar.gz" --transform "s|^${DISTRO}|${NAME}|" "${DISTRO}"
	echo "${NAME}.tar.gz:"
	tar -tzf "${DESTDIR}/${NAME}.tar.gz"
done

cd "${DESTDIR}"
ls ./*.tar.gz >/dev/null
sha256sum ./*.tar.gz | sed 's| \./| |' >SHA256SUMS
cat SHA256SUMS
