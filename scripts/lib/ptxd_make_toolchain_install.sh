#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_toolchain_install() {
    local tmpfile install_helper
    local prefix_cross="$(ptxd_get_ptxconf PTXCONF_PREFIX_CROSS)"
    local sysroot="${ptx_install_destdir}${prefix_cross}"
    local install_source="${PTXDIST_SYSROOT_CROSS}${prefix_cross}"

    echo "Installing to ${sysroot} ..."

    if [ -d "${sysroot}" ]; then
	if [ -z "$(find "${sysroot}" -maxdepth 0 -empty)" -a -z "${PTXDIST_FORCE}" ]; then
	    ptxd_bailout "${sysroot} is not empty!" \
		"Use --force to remove the existing content first."
	fi
    fi

    mkdir -p "${sysroot}" 2>/dev/null &&
    tmpfile="$(mktemp "${sysroot}/touch.XXXXXXXX" 2>/dev/null)" &&
    rm "${tmpfile}"
    if [ $? -ne 0 ]; then
	echo
	echo "'${sysroot}' is not writable."
	read -t 5 -p "Press enter to install with sudo!"
	if [ ${?} -ne 0 ]; then
	    echo
	    return 1
	fi
	install_helper=sudo
    fi
    ${install_helper} rm -rf "${sysroot}" &&
    ${install_helper} mkdir -p $(dirname "${sysroot}") &&
    ${install_helper} cp -a --no-preserve=ownership \
	"${install_source}" $(dirname "${sysroot}") &&
    ptxd_make_strip_toolchain
}
export -f ptxd_make_toolchain_install
