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
    # in the final toolchain
    rmdir --ignore-fail-on-non-empty \
	{"${sysroot_cross}","${sysroot_target}"{,/usr}}/{etc,lib,{,s}bin,include,{,share/}man/{man*,},share} 2>/dev/null
    # errors may occur because the dirs may not exist (e.g. for 'ptxdist print').
    true
}

ptxd_make_toolchain_cleanup
