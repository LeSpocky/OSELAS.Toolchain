#!/bin/bash

set -e

origin=origin
v="v"

branch="$(git symbolic-ref HEAD)"
branch="${branch##refs/heads/}"

trap_exit_handler() {
    if [ -n "${tmp}" -a -d "${tmp}" ]; then
	rm -rf "${tmp}"
    fi
}
trap 'trap_exit_handler' 0 1 15

# Update index only on r/w media
if [ -w . ]; then
    git update-index --refresh --unmerged > /dev/null || true
fi

# Check for uncommitted changes
if git diff-index --name-only HEAD \
    | read dummy; then
    echo "tree dirty, refusing to make a release" >&2
    exit 1
fi

# guess if we're going to make a new or stable release
case "${branch}" in
    master)
	release="${v}$(date +%Y.%m).0"
	prev_release="${v}*.0"
	;;
    stable/*)
	release="${v}${branch##stable/*-}"
	release="${release%.x}"
	inc="$(git tag -l "${release}.*" | wc -l)"
	if [ ${inc} -eq 0 ]; then
	    echo "about to make stable a release for '${release}', but no '.0' found" >&2
	    exit 1
	fi
	prev_release="${release}.$((inc - 1))"
	release="${release}.${inc}"
	;;
    *)
	echo "please checkout either master or stable branch" >&2
	exit 1
	;;
esac

# get previous release
prev_release=( $(git tag -l "${prev_release}" | sort -r -n) )
if [ -z "${prev_release}" ]; then
    echo "previous release not found" >&2
    exit 1
fi

# check if to-be-made release already exists
if git rev-parse -q --verify "refs/tags/$release" >/dev/null 2>&1; then
    echo "release '${release}' already exists" >&2
    exit 1
fi

config_release="$(sed -n 's/^PTXCONF_PROJECT="OSELAS.Toolchain-\(.*\)"/\1/p' ptxconfigs/*.ptxconfig | sort -u)"
if [ "${release#${v}}" != "${config_release}" ]; then
	echo "release version(s) from the ptxconfigs (${config_release}) do not match '${release#${v}}'" >&2
	exit 1
fi

if grep -q UNRELEASED debian/changelog; then
	echo "debian changelog entry must not be UNRELEASED" >&2
	exit 1
fi

debian_release="$(sed -n '1s/.*(\(.*\)-.*).*/\1/p' debian/changelog)"
if [ "${release#${v}}" != "${debian_release}" ]; then
	echo "release version from the debian/changelog (${debian_release}) does not match '${release#${v}}'" >&2
	exit 1
fi

if [ "${1}" == "--test" ]; then
	echo "test mode: all checks ok -- stopping"
	exit
fi

tmp="$(mktemp -d /tmp/${0##*/}.XXXXXX)"
log="${tmp}/log"

# create tag message
printf "${release}\n\n" > "${log}"
git shortlog "${prev_release}"..HEAD >> "${log}"
echo "creating tag '${release}'"
git tag -s -F "${log}" "${release}"

# create tarball
here="$(pwd)"
pushd "${tmp}" >/dev/null
git clone "${here}" "${release}"
cd "${release}"
git checkout "${release}"

make dist
popd >/dev/null

# now push to origin
echo
echo "pushing '${release}' to $origin, press '[Ctrl] + c' to abort"
echo
read
git push "${origin}" "${branch}"
git push "${origin}" "${release}"
mv "${tmp}/${release}/"*tar.bz2* "${here}"
