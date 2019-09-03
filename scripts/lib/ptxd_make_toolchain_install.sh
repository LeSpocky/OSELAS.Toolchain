#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_toolchain_install() {
    local tmpfile install_helper
    local prefix="$(ptxd_get_ptxconf PTXCONF_PREFIX_CROSS)"
    local install_prefix="${ptx_install_destdir}${prefix}"
    local install_source="${PTXDIST_SYSROOT_CROSS}${prefix}"

    echo "Installing to ${install_prefix} ..."

    if [ -d "${install_prefix}" ]; then
	if [ -z "$(find "${install_prefix}" -maxdepth 0 -empty)" -a -z "${PTXDIST_FORCE}" ]; then
	    ptxd_bailout "${install_prefix} is not empty!" \
		"Use --force to remove the existing content first."
	fi
    fi

    mkdir -p "${install_prefix}" 2>/dev/null &&
    tmpfile="$(mktemp "${install_prefix}/touch.XXXXXXXX" 2>/dev/null)" &&
    rm "${tmpfile}"
    if [ $? -ne 0 ]; then
	echo
	echo "'${install_prefix}' is not writable."
	read -t 5 -p "Press enter to install with sudo!"
	if [ ${?} -ne 0 ]; then
	    echo
	    return 1
	fi
	install_helper=sudo
    fi
    ${install_helper} rm -rf "${install_prefix}" &&
    ${install_helper} mkdir -p $(dirname "${install_prefix}") &&
    ${install_helper} cp -a --no-preserve=ownership \
	"${install_source}" $(dirname "${install_prefix}")
}
export -f ptxd_make_toolchain_install
