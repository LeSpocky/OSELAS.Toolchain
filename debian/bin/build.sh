#!/bin/bash

DIST="$(lsb_release -i -s)"
RELEASE="$(lsb_release -c -s)"
if [ "${DIST}" = "Debian" ]; then
	VERSION="$(cat /etc/debian_version)"
	VERSION="${VERSION%%.*}"
	PREFIX="~deb"
elif [ "${DIST}" = "Ubuntu" ]; then
	VERSION="$(lsb_release -r -s)"
	PREFIX="-ubuntu"
else
	echo "Unknown Distribution '${DIST}'"
	exit 1
fi

if ! [[ "${VERSION}" =~ .*/sid ]]; then
	git checkout debian/changelog
	dch --local ${PREFIX}${VERSION}+ --distribution ${RELEASE} "Rebuild for ${RELEASE}" || exit
fi

debian/bin/gencontrol.sh "${@}"

dpkg-buildpackage -uc -b -nc
