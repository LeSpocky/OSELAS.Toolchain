#!/bin/bash
#
# Copyright (C) 2021 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#


ptxd_make_icecc_check() {
    local sysroot_host

    if [ -z "${PTXDIST_ICECC}" ]; then
	return
    fi

    # old icerun versions cannot handle relative paths
    sysroot_host="$(ptxd_get_ptxconf PTXCONF_SYSROOT_HOST)" &&
    sysroot_host=".${sysroot_host#${PTXDIST_WORKSPACE}}" &&
    mkdir -p "${sysroot_host}/bin" &&
    ln -s /bin/true "${sysroot_host}/bin/test-icerun" &&
    icerun "${sysroot_host}/bin/test-icerun" || {
	echo "Disabling broken icerun!"
	unset PTXDIST_ICERUN
    }
    rm -f "${sysroot_host}/bin/test-icerun"
}

ptxd_make_icecc_check

