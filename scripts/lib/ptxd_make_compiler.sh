#!/bin/bash
#
# Copyright (C) 2020 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# helper to allow late wrapper / icecc setup
#
ptxd_make_setup_target_compiler() {
    local wrapper_dir sysroot_host
    local toolchain compiler_prefix

    sysroot_host="$(ptxd_get_ptxconf PTXCONF_SYSROOT_HOST)"
    wrapper_dir="${sysroot_host}/lib/wrapper"

    toolchain="${1}"
    compiler_prefix="$(ptxd_get_ptxconf PTXCONF_COMPILER_PREFIX)"

    ptxd_lib_setup_target_wrapper &&
    if [ -n "${PTXDIST_ICECC}" ] && "${PTXDIST_ICECC}" --help | grep -q ICECC_ENV_COMPRESSION; then
	PTXDIST_ICECC_CREATE_ENV_REAL="${PTXDIST_ICECC_CREATE_ENV}" \
	PTXDIST_ICECC_CREATE_ENV="${PTXDIST_WORKSPACE}/scripts/icecc-create-env-wrapper" \
	ptxd_lib_setup_target_icecc
    fi
}
export -f ptxd_make_setup_target_compiler

