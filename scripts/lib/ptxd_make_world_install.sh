#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# custom ptxd_make_world_install_pack
#
# * skip rpath fixup. Not needed and may cause problems with target file
#   in cross packages
# * skip anything else that is not needed for the toolchain
#
ptxd_make_world_install_pack() {
    ptxd_make_world_init &&

    if [ -z "${pkg_pkg_dir}" ]; then
	# no pkg dir -> assume the package has nothing to install.
	return
    fi &&

    # remove empty dirs
    test \! -e "${pkg_pkg_dir}" || \
	find "${pkg_pkg_dir}" -depth -type d -print0 | xargs -r -0 -- \
	rmdir --ignore-fail-on-non-empty -- &&
    check_pipe_status &&

    if [ \! -e "${pkg_pkg_dir}" ]; then
	if [ -e "${pkg_dir}" ]; then
	    ptxd_warning "PKG didn't install anything to '${pkg_pkg_dir}'"
	fi
	return
    fi &&

    # remove la files. They are not needed
    find "${pkg_pkg_dir}" \( -type f -o -type l \) -name "*.la" -print0 | xargs -r -0 rm &&
    check_pipe_status
}
export -f ptxd_make_world_install_pack
