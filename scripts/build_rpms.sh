#!/bin/bash
set -ex

[ -e /host ] && DEST=/host || DEST=/tmp
export GITHUB2SPEC_DEST=${GITHUB2SPEC_DEST:-${DEST}/specs}
export RPMDEST=${RPMDEST:-${DEST}/rpms}

mkdir -p "${RPMDEST}"
cd "${GITHUB2SPEC_DEST}"
#until [ -d .git ]; do
#  cd ..
#done
#
#git diff --name-only *-$(uname -i).spec | while read SPEC; do
#  rpmbuild -ba "${SPEC}"
#done
find "${GITHUB2SPEC_DEST}/" -name '*.spec' | while read -r SPEC; do
	# rendered from rpmbuilder/templates/fetch-rpm.sh.j2: a script that downloads a prebuilt rpm into RPMDEST
	if [ "$(head -c2 "${SPEC}")" = '#!' ]; then
		bash "${SPEC}"
	else
		rpmbuild -ba "${SPEC}"
	fi
done

for RPM in ~/rpmbuild/RPMS/*/*.rpm; do
	[ -e "${RPM}" ] || continue
	cp "${RPM}" "${RPMDEST}"
done

ls "${RPMDEST}/"*.rpm

echo Building rpms finished succesfully
