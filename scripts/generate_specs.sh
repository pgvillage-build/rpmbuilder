#!/bin/bash
set -ex

[ -e /host ] && DEST=/host || DEST=/tmp
export GITHUB2SPEC_DEST=${GITHUB2SPEC_DEST:-${DEST}/specs}

mkdir -p "${GITHUB2SPEC_DEST}"

specbuilder

find /host/specs

echo Generating specs finished succesfully
