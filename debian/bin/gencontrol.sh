#!/bin/bash -e

die() {
	echo >&2 "$@"
	return 1
}

# This script assumes to have CWD = toplevel of OSELAS.Toolchain
test -f debian/changelog || die "debian/changelog not found"
vendor="$(dpkg-vendor --query Vendor)"
if [ "${vendor}" != "Debian" -a "${vendor}" != "Ubuntu" ]; then
	die "This script only works on Debian"
fi

toolchain_path_version=$(dpkg-parsechangelog -SVersion | sed -e 's/-.*$//')
toolchain_version="$(tr A-Z a-z <<< "${toolchain_path_version}")"
newcontrol=$(mktemp debian/control.XXXXXXXXX)
trap 'rm -v -- "$newcontrol"' INT QUIT EXIT

cat > "$newcontrol" << EOF
Source: oselas.toolchain
Section: devel
Priority: optional
Maintainer: PTXdist Devevelopers <ptxdist@pengutronix.de>
Homepage: https://www.pengutronix.de/software/toolchain.html
Bugs: mailto:bugs@pengutronix.de
Build-Depends: debhelper (>= 9), libncurses-dev, python3-dev | python3.8-dev, bison, flex
EOF

if [ $# -gt 0 ]; then
	configs=( "${@}" )
else
	if [ "$(lsb_release -r -s)" = "16.04" ]; then
		# Skip the clang toolchains on Ubuntu Xenial
		configs=( $(ls ptxconfigs/*.ptxconfig | grep -v clang) )
	else
		# Skip the corresponding non-clang toolchains
		configs=( $(comm -3 <(ls ptxconfigs/*.ptxconfig) <(ls ptxconfigs/*.ptxconfig | sed -n 's/_clang-[^_]*_/_/p')) )
	fi
fi
for configfile in "${configs[@]}"; do
	toolchain_name="$(basename "${configfile}" .ptxconfig | sed s/_/-/g)"
	pkg="oselas.toolchain-${toolchain_version}-${toolchain_name}"
	gnutriplet="$(sed -n 's/^PTXCONF_GNU_TARGET="\(.*\)"/\1/p' "$configfile")"

	cat >> "$newcontrol" << EOF

Package: $pkg
Architecture: any
Depends: \${shlibs:Depends}, \${misc:Depends}
Recommends: libgmp-dev, libmpc-dev, libmpfr-dev
Description: OSELAS Toolchain for ${gnutriplet}
 
Package: oselas.toolchain-${toolchain_version}-${gnutriplet/_/-}
Architecture: all
Depends: $pkg
Description: Meta package depending on latest OSELAS Toolchain for ${gnutriplet}

Package: oselas.toolchain-${toolchain_version%.*}-${gnutriplet/_/-}
Architecture: all
Depends: $pkg
Description: Meta package depending on latest OSELAS Toolchain for ${gnutriplet}
EOF

	echo "/opt/OSELAS.Toolchain-${toolchain_path_version}/${gnutriplet}" > "debian/${pkg}.install"
done

if ! cmp -s "$newcontrol" "debian/control"; then
	mv "$newcontrol" "debian/control"
	trap '' INT QUIT EXIT

	echo >&2 debian/control was updated successfully.
	echo >&2 Nevertheless return failure here to eventually abort
	echo >&2 building because the debian/control must not change
	echo >&2 during a build.

	exit 1
else
	touch "debian/control"
fi
