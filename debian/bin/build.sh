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
	export DEB_BUILD_OPTIONS=noautodbgsym
else
	echo "Unknown Distribution '${DIST}'"
	exit 1
fi

cfgs=( ptxconfigs/*.ptxconfig )
PTX_VERSION=$(sed -n -e 's/^PTXCONF_PROJECT="OSELAS.Toolchain-\(.*\)"$/\1/p' ${cfgs[0]})
DEBIAN_VERSION="$(sed -n '1s/.*(\([^-]*\)-.*).*/\1/p' debian/changelog)"
if [ "${PTX_VERSION}" != "${DEBIAN_VERSION}" ]; then
	echo "release version from the debian/changelog (${DEBIAN_VERSION}) does not match '${PTX_VERSION}'"
	exit 1
fi

if ! [[ "${VERSION}" =~ .*/sid ]]; then
	git checkout debian/changelog
	dch --local ${PREFIX}${VERSION}+ --distribution ${RELEASE} "Rebuild for ${RELEASE}" || exit
fi

debian/bin/gencontrol.sh "${@}"

dpkg-buildpackage -uc -b -nc
