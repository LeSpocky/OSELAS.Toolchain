#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_toolchain_cleanup() {
    local sysroot_cross="$(ptxd_get_ptxconf PTXCONF_SYSROOT_CROSS)"
    local sysroot_target="$(ptxd_get_ptxconf PTXCONF_SYSROOT_TARGET)"

    # packages install to pkgdir anyways and this avoid empty directories
    # in the final toolchain, but ensure that /lib and /usr/lib exist.
    # The are needed to resolve .../lib/../lib64/...
    if [ -d "${sysroot_cross}" ]; then
        rmdir --ignore-fail-on-non-empty \
	    {"${sysroot_cross}","${sysroot_target}"}/{etc,usr/{lib,{,s}bin,include,{,share/}{man/{man*,},}}} &&
	mkdir -p "${sysroot_target}"{,/usr}/lib
    fi
}

ptxd_make_toolchain_cleanup
